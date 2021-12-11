    //
    //  RegisterViewModelContract.swift
    //  PhotosApp
    //
    //  Created by Amr Muhammad on 12/10/21.
    //  Copyright © 2021 Amr Muhammad. All rights reserved.
    //

    import Foundation

    protocol RegisterViewModelContract: BaseViewModelContract{
        func validateRegisterdData(phoneNumber:String,password:String,confirmPassword:String)
}
