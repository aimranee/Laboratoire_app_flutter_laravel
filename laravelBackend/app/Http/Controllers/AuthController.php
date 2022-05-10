<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;

class AuthController extends Controller
{
    //
    public function register(Request $request){
        //validate fields
        $attrs = $request->validate([
            'first_name' => 'required|string',
            'last_name' => 'required|string',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|min:6|confirmed',
            'phone' => 'required|min:10|integer',
            'address' => 'required|string',
            'blood_type' => 'required|string',
            'birthday' => 'required|date',
            'cin' => 'required|string',
            'sex' => 'required|string',
            'family_situation' => 'required|string',
            'disease_state' => 'required|string',
            'has_ramid' => 'required|boolean',
            'has_cnss' => 'required|boolean',
        ]);
            $user = new User();
            $user->first_name= $attrs['first_name'];
           $user->last_name= $attrs['last_name'];
           $user->email= $attrs['email'];
           $user->password= bcrypt($attrs['password']);
           $user->phone= $attrs['phone'];
           $user->address= $attrs['address'];
           $user->blood_type= $attrs['blood_type'];
           $user->birthday= $attrs['birthday'];
           $user->cin= $attrs['cin'];
           $user->sex= $attrs['sex'];
           $user->family_situation= $attrs['family_situation'];
           $user->disease_state= $attrs['disease_state'];
           $user->has_ramid= $attrs['has_ramid'];
           $user->has_cnss= $attrs['has_cnss'];
           $user->save();


        //return user & token in response
        return response([
            'user' => $user,
            'token' => $user->createToken('secret')->plainTextToken
        ]);
    }
    //login users
    public function login(Request $request){
        //validate fields
        $attrs = $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        //create user
        if(!Auth::attempt($attrs))
        {
            return response([
                'message' => 'Invalid credentials.'
            ], 403);
        }

        //return user & token in response
        return response([
            'user' => auth()->user(),
            'token' => auth()->user()->createToken('secret')->plainTextToken
        ],200);
    }

    //logOut user
    public function logout()
    {
        auth()->user()->tokens()->delete();
        return response([
            'message' => 'Logout success.'
        ],200);
    }

    //get user details
    public function user()
    {
        return response([
            'user' => auth()->user()
        ], 200);
    }
}
