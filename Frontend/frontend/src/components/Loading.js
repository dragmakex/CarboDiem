import React from "react";

export function Loading() {
  return (
      <div
        style={{
          position: "absolute",
          zIndex: 3,
          top: "50%",
          left: "50%",
          width: "100px",
          height: "50px",
          marginLeft: "-50px",
          marginTop: " -25px",
          textAlign: "center",
        }}
      >
        <div>
          <progress class="matter-progress-circular"></progress>
        </div>
      </div>
  );
}
