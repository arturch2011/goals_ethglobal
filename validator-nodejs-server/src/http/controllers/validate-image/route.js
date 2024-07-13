import { openai } from "../../../lib/openai.js"

export async function validateImageRoutes(app) {
    app.post("/validate-image", async(req, res) => {
        const imageHash = req.body.imageHash;
        const validationPrompt = req.body.validationPrompt;
        const response = await openai.chat.completions.create({
            model: "gpt-4o",
            messages: [
              {
                role: "user",
                content: [
                  { type: "text", text: validationPrompt },
                  {
                    type: "image_url",
                    image_url: {
                      "url": `https://gateway.lighthouse.storage/ipfs/${imageHash}`,
                    //   "url": "https://media.self.com/photos/57d8b8874b76f0f832a0ecff/master/w_1600,c_limit/running-marathon-data.jpg",
                      "detail": "high"
                    },
                  },
                ],
              },
            ],
          });
          console.log(response.choices[0]);
          const formatedResponse = response.choices[0].message.content.toLocaleLowerCase();
          const cleanedResponse = formatedResponse.replace(/[^a-z]/g, '');
          if (cleanedResponse === "true") {
            return { response: true }
          } else {
            return { response: false }
          }
    })
}
