    // if (jsonDecode(response.body)['success'] == 'true') {
    //   print('SUCCESS GET TOKEN');
    //   auth = PusherAuth(
    //     'https://api.chatapp.online/broadcasting/auth',
    //     headers: {
    //       'Authorization': jsonDecode(response.body)['data']['accessToken'],
    //     },
    //   );
    // } else {
    //   print('REFRESH TOKEN');
    //   http.Response response = await http.post(
    //     Uri.parse('https://api.chatapp.online/v1/tokens/refresh'),
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Refresh': 'quo',
    //     },
    //   );
    //   auth = PusherAuth(
    //     'https://api.chatapp.online/broadcasting/auth',
    //     headers: {
    //       'Authorization': jsonDecode(response.body)['data']['accessToken'],
    //     },
    //   );
    // }