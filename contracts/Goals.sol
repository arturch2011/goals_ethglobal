// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./GoalsToken.sol";

contract Goals {
    address public owner;
    GoalsToken public token;

    struct Goal {
        uint256 id;
        string name;
        string description;
        string category;
        string frequency;
        uint256 targetFreq;
        uint256 minimumBet;
        uint256 startDate;
        uint256 endDate;
        bool isStarted;
        bool isCompleted;
        bool isPublic;
        address creator;
        uint256 totalBet;
        uint256 preFund;
        uint256 totalParticipants;
        uint256 maxParticipants;
        string[] URI; // IPFS URIs
        string typeTragetFreq;
        uint256 quantity;
        uint256 numFreq;
    }

    Goal[] public goals;

    mapping(uint256 => address[]) public participants; //Link goal id to participants
    mapping(uint256 => mapping(address => uint256)) public bets; // Link goal id to participants and their bets
    mapping(uint256 => mapping(address => bool)) public isParticipant; // Link goal id to participants and their status
    mapping(uint256 => mapping(address => uint256)) public participantsFreq; // Link goal id to participants and their frequency
    mapping(uint256 => mapping(address => string[])) public participantsURI; // Link goal id to participants and their image URIs
    mapping(uint256 => mapping(address => uint256))
        public participantsAutenticatedFreq; // Link goal id to the number of times a participant had their frequency authenticated
    mapping(uint256 => mapping(address => uint256[])) public validatedURI; // Link goal id to participants and their validated URIs

    mapping(address => uint[]) public myGoals; // Link participant to their goals
    mapping(address => uint[]) public myEnteredGoals; // Link participant to the goals they have entered

    constructor(address _goalsTokenAddr) {
        token = GoalsToken(_goalsTokenAddr);
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public {
        require(msg.sender == owner, "You are not the owner");
        owner = _newOwner;
    }

    function createGoal(
        string memory _name,
        string memory _description,
        string memory _category,
        string memory _frequency,
        uint256 _target,
        uint256 _minimumBet,
        uint256 _startDate,
        uint256 _endDate,
        bool _isPublic,
        uint256 _preFund,
        uint256 _maxParticipants,
        string[] memory _URI,
        string memory _typeTragetFreq,
        uint256 _quantity,
        uint256 _numFreq
    ) public {
        require(_startDate < _endDate, "Start date must be before end date");
        require(_target > 0, "Target must be greater than 0");
        require(
            _maxParticipants > 0,
            "Max participants must be greater than 0"
        );
        require(_URI.length > 0, "URI must not be empty");
        require(token.balanceOf(msg.sender) >= _preFund, "Insufficient funds");
        myGoals[msg.sender].push(goals.length);
        goals.push(
            Goal({
                id: goals.length, // ID of the goal
                name: _name, // Name of the goal
                description: _description, // Description of the goal
                category: _category, // Category of the goal
                frequency: _frequency, // Tipo da frequencia (diario, semanal, mensal, anual, etc.)
                targetFreq: _target, // Numero de vezes para atingir 100% do objetivo
                minimumBet: _minimumBet, // Aposta minima para entrar no goal
                startDate: _startDate, // Data de inicio do goal
                endDate: _endDate, // Data de fim do goal
                isStarted: false, // Indica se o goal ja comecou
                isCompleted: false, // Indica se o goal ja foi completado
                isPublic: _isPublic, // Indica se o goal é publico
                creator: msg.sender, // Endereco do criador do goal
                totalBet: _preFund, // Total de apostas feitas no goal
                preFund: _preFund, // Valor adicionado como bonus no momento de criação do goal
                totalParticipants: 0, // Total de participantes no goal
                maxParticipants: _maxParticipants, // Numero maximo de participantes no goal
                URI: _URI, // URIs das imagens para fazer o display do goal
                typeTragetFreq: _typeTragetFreq, // Tipo de objetivo (Km, Litros, Repetições, etc.)
                quantity: _quantity, // Numero de vezes por semana, ou mes. Se a frequencia for diaria é uma vez por dia
                numFreq: _numFreq // Metrica maxima atingida ex: devo correr 5 km por semana durante 1 mes, o nuFreq é 20 km
            })
        );
        token.transferFrom(msg.sender, address(this), _preFund);
    }

    function startGoal(uint256 _goalId) public {
        require(
            goals[_goalId].creator == msg.sender,
            "You are not the creator of this goal"
        );
        require(goals[_goalId].isStarted == false, "Goal has already started");
        require(
            goals[_goalId].totalParticipants > 0,
            "No participants in this goal"
        );
        goals[_goalId].isStarted = true;
    }

    function enterGoal(uint256 _goalId, uint256 _bet) public {
        require(
            _bet >= goals[_goalId].minimumBet,
            "Bet must be greater than minimum bet"
        );
        require(token.balanceOf(msg.sender) >= _bet, "Insufficient funds");
        require(
            goals[_goalId].totalParticipants < goals[_goalId].maxParticipants,
            "Goal is full"
        );
        require(
            goals[_goalId].isCompleted == false,
            "Goal has already been completed"
        );
        require(
            isParticipant[_goalId][msg.sender] == false,
            "You have already entered this goal"
        );
        require(goals[_goalId].isStarted == false, "Goal has already started");
        bets[_goalId][msg.sender] = _bet;
        goals[_goalId].totalBet += _bet;
        goals[_goalId].totalParticipants += 1;
        participants[_goalId].push(msg.sender);
        isParticipant[_goalId][msg.sender] = true;
        token.transferFrom(msg.sender, address(this), _bet);
        myEnteredGoals[msg.sender].push(_goalId);
    }

    function updateFrequency(uint256 _goalId, string memory _imgaeURI) public {
        require(
            isParticipant[_goalId][msg.sender] == true,
            "You are not a participant of this goal"
        );
        require(
            goals[_goalId].isCompleted == false,
            "Goal has already been completed"
        );
        require(goals[_goalId].isStarted == true, "Goal has not started yet");
        // require(goals[_goalId].endDate > block.timestamp, "Goal has ended");
        require(
            participantsFreq[_goalId][msg.sender] < goals[_goalId].targetFreq,
            "You have reached the maximum number of frequencies"
        );

        participantsURI[_goalId][msg.sender].push(_imgaeURI);
        participantsFreq[_goalId][msg.sender] += 1;
    }

    function autenticateFrequency(
        uint256 _goalId,
        address _participant,
        uint _number,
        uint[] memory _uriIndex
    ) public {
        require(
            goals[_goalId].creator == msg.sender || owner == msg.sender,
            "You are not the creator of this goal"
        );
        require(
            isParticipant[_goalId][_participant] == true,
            "The address is not a participant of this goal"
        );
        require(
            goals[_goalId].isCompleted == false,
            "Goal has already been completed"
        );
        require(goals[_goalId].isStarted == true, "Goal has not started yet");
        // require(goals[_goalId].endDate > block.timestamp, "Goal has ended");
        require(
            participantsAutenticatedFreq[_goalId][_participant] <
                goals[_goalId].targetFreq,
            "This participant has reached the maximum number of frequencies"
        );
        // require(participantsURI[_goalId][_participant].length > _uriIndex.length, "URI index out of range");

        for (uint i = 0; i < _uriIndex.length; i++) {
            validatedURI[_goalId][_participant].push(_uriIndex[i]);
        }

        participantsAutenticatedFreq[_goalId][_participant] += _number;
    }

    function completeGoal(uint256 _goalId) public {
        require(
            goals[_goalId].creator == msg.sender,
            "You are not the creator of this goal"
        );
        require(
            goals[_goalId].isCompleted == false,
            "Goal has already been completed"
        );

        goals[_goalId].isCompleted = true;

        uint goalFreq = goals[_goalId].targetFreq;
        uint goalFreq85 = (goalFreq * 85) / 100;

        uint totalParticipants = goals[_goalId].totalParticipants;
        uint numPremParts = 0;
        uint premPremParts = 0;
        uint premCompParts = 0;
        uint premNParts = 0;

        for (uint i = 0; i < totalParticipants; i++) {
            uint partFreq = participantsAutenticatedFreq[_goalId][
                participants[_goalId][i]
            ];
            if (partFreq >= goalFreq) {
                numPremParts = numPremParts + 1;
                uint va = bets[_goalId][participants[_goalId][i]];
                premPremParts = premPremParts + va;

                token.transfer(participants[_goalId][i], va);
            } else if (goalFreq85 <= partFreq && partFreq < goalFreq) {
                uint val = bets[_goalId][participants[_goalId][i]];
                // numCompParts = numCompParts + 1;
                premCompParts = premCompParts + val;
                token.transfer(participants[_goalId][i], val);
            } else {
                uint v = ((bets[_goalId][participants[_goalId][i]] * partFreq) /
                    goalFreq); // Aqui o negocio pega,
                premNParts = premNParts + v;
                token.transfer(participants[_goalId][i], v);
            }
        }

        uint prize = goals[_goalId].totalBet; //300
        uint prizeGoals = (prize - premCompParts - premNParts - premPremParts) /
            2; //300 - 100 = 200
        uint prizePerPart;
        if (numPremParts == 0) {
            prizePerPart = prizeGoals;
            token.transfer(payable(owner), prizeGoals * 2);
        } else {
            prizePerPart = prizeGoals / numPremParts;

            for (uint i = 0; i < totalParticipants; i++) {
                uint partFreq = participantsFreq[_goalId][
                    participants[_goalId][i]
                ];
                if (partFreq == goalFreq) {
                    token.transfer(participants[_goalId][i], prizePerPart);
                }
            }
            token.transfer(payable(owner), prizeGoals);
        }
    }

    function getGoal() public view returns (Goal[] memory) {
        return goals;
    }

    function getMyProgress(uint256 _goalId) public view returns (uint256) {
        require(
            isParticipant[_goalId][msg.sender] == true,
            "You are not a participant of this goal"
        );
        return participantsAutenticatedFreq[_goalId][msg.sender];
    }

    function getMyBets(uint256 _goalId) public view returns (uint256) {
        require(
            isParticipant[_goalId][msg.sender] == true,
            "You are not a participant of this goal"
        );
        return bets[_goalId][msg.sender];
    }

    function getMyGoals() public view returns (uint[] memory) {
        return myGoals[msg.sender];
    }

    function getMyEnteredGoals() public view returns (uint[] memory) {
        return myEnteredGoals[msg.sender];
    }

    function getParticipants(
        uint256 _goalId
    ) public view returns (address[] memory) {
        return participants[_goalId];
    }

    function getParticipantsUri(
        uint256 _goalId,
        address _participant
    ) public view returns (string[] memory) {
        return participantsURI[_goalId][_participant];
    }

    function getAutenticatedUri(
        uint256 _goalId,
        address _participant
    ) public view returns (uint[] memory) {
        return validatedURI[_goalId][_participant];
    }
}
