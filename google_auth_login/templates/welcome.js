// const test = () => {
//   window.location.replace(
//     "https://accounts.google.com/o/oauth2/v2/auth?\
// scope=https%3A//www.googleapis.com/auth/userinfo.profile&\
// access_type=offline&\
// include_granted_scopes=true&\
// response_type=code&\
// state=state1234&\
// redirect_uri=http://localhost:3000/done&\
// client_id=24685204688-9o92rfk1vtero9m8uc36vp3gicucjtf8.apps.googleusercontent.com"
//   );
// };


// const test = () => {
//   window.location.replace("http://localhost:3000/oauth")
// };

const test = () => {
  fetch("/oauth")
};
