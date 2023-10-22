import React from "react";

import { NetworkErrorMessage } from "./NetworkErrorMessage";

export function ConnectWallet({ connectWallet, networkError, dismiss }) {
  return (
    <div
    style={{
      position: "absolute",
      zIndex: 3,
      top: "50%",
      left: "50%",
      width: "240px",
      height: "100px",
      marginLeft: "-120px",
      marginTop: " -50px",
      textAlign: "center",
    }}
    >
    <div className="container">
      <div className="row justify-content-md-center">
        <div className="col-12 text-center">
          {/* Wallet network should be set to Localhost:8545. */}
          {networkError && (
            <NetworkErrorMessage 
              message={networkError} 
              dismiss={dismiss} 
            />
          )}
        </div>
        <div className="col-6 p-4 text-center">
          <p class="matter-body1">Please connect to your wallet.</p>
          <button class="matter-button-contained" onClick={connectWallet}>CONNECT WALLET</button>
        </div>
      </div>
    </div>
    </div>
  );
}
