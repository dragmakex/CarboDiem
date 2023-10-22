import React from "react";

export function Burn({ transferTokens, tokenSymbol }) {
  return (
    <div>
        <div style={{marginLeft: "30px"}}>
          <h3 class="matter-h3">🔥 Burn</h3>
        </div>
        <hr/>
        <div
            style={{
            position: "absolute",
            zIndex: 3,
            top: "50%",
            left: "50%",
            width: "500px",
            height: "200px",
            marginLeft: "-250px",
            marginTop: " -100px",
            textAlign: "center",
            }}
        >
          <form
            onSubmit={(event) => {
            // This function just calls the transferTokens callback with the
            // form's data.
            event.preventDefault();

            const formData = new FormData(event.target);
            const to = "0x0000000000000000000000000000000000000000";
            const amount = formData.get("amount");

            if (to && amount) {
                transferTokens(to, amount);
            }
            }}
        >
            <div
                style={{
                    position: "absolute",
                    zIndex: 3,
                    top: "50%",
                    left: "0%",
                    width: "250px",
                    height: "200px",
                    marginLeft: "-125px",
                    marginTop: " -100px",
                    textAlign: "center",
                }}
            >
            <label class="matter-textfield-standard">
                <input type="number" step="1" name="amount" placeholder="" required />
                <span>Amount of {tokenSymbol}</span>
            </label>
            <div
                style={{
                    position: "absolute",
                    zIndex: 3,
                    top: "50%",
                    right: "0%",
                    width: "250px",
                    height: "200px",
                    marginRight: "-450px",
                    marginTop: " -85px",
                    textAlign: "center",
                }}
            >
                <button class="matter-button-contained" type="submit">BURN</button>
            </div>
            </div>
          </form>
        </div>
    </div>
  );
}
