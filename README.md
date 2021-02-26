<p align="center"><img src="images/logo_horizontal.png" alt="Logo" width="544" height="80"></p>
</a>

  <h3 align="center">Motor de Autenticación Universal - iOS</h3>

  <p align="center">MAU</p>
  
<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Tabla de contenidos</summary>
  <ol>
    <li>
      <a href="#acerca-del-proyecto">Acerca del proyecto</a>
      <ul>
        <li><a href="#tecnologías-utilizadas">Tecnologías utilizadas</a></li>
      </ul>
    </li>
    <li>
      <a href="#introducción">Introducción</a>
      <ul>
        <li><a href="#prerrequisitos">Prerrequisitos</a></li>
        <li><a href="#instalación">Instalación</a></li>
      </ul>
    </li>
    <li>
    <a href="#uso">Uso</a>
    <ul>
        <li><a href="#motor-de-autenticación">Motor de Autenticación</a></li>
        <li><a href="#consumo-de-servicios">Consumo de servicios</a></li>
      </ul>
    </li>
    <li><a href="#autor">Autor</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->

## Acerca del proyecto

Biblioteca del Motor de Autenticación Universal que incluye las siguientes características:
* Facilidad para autenticar a un cliente registrado en las aplicaciones de Profuturo.
* Incluye los siguientes consumos de servicios web:
	* Obtener perfil de usuario
	* Crear perfil de usuario
	* Obtener matriz de criticidad
	* Obtener aviso de privacidad
	* Obtener estado del aviso de privacidad
	* Guardar respuesta del aviso de privacidad
	* Consultar derechos ARCO
	* Consultar derechos REUS
	* Enviar y reenviar token (OTP) por SMS
	* Enviar y reenviar token (Email) por Email
	* Validar token (OTP)
	

### Tecnologías utilizadas

La biblioteca fue creada utilizando la tecnología <b>Swift</b> y utiliza los siguientes pods para su funcionamiento:
* [SVPinView](https://github.com/xornorik/SVPinView)
* [Alamofire (4.8.1)](https://github.com/Alamofire/Alamofire)
* [AlamofireObjectMapper (5.2.0)](https://github.com/tristanhimmelman/AlamofireObjectMapper)
* [Lottie](https://github.com/airbnb/lottie-ios)
* [ReachabilitySwift](https://github.com/ashleymills/Reachability.swift)
* [FWFaceAuth (2.1.12)](https://github.com/grupo-profuturo/ios-facephi-framework-pod)

<!-- GETTING STARTED -->

## Introducción

La biblioteca se encuentra disponible en Cocoapods, a continuación se mostrará el proceso para instalar el administrador de dependencias y el repositorio donde se encuentra la biblioteca.

### Prerrequisitos

Necesitamos Cocoapods en nuestra computadora, se instala utilizando el siguiente comando:
  ```ruby
  sudo gem install cocoapods
  ```

### Instalación

1. En la terminal, ejecuta el siguiente comando para agregar el repositorio privado:
    ```ruby
    pod repo add ios-framework-pod-spec https://github.com/grupo-profuturo/ios-framework-pod-spec
    ```
2. Ahora navega a donde se encuentra tu proyecto de Xcode e ejecuta:
   ```ruby
   pod init
   ```
3. Abre el archivo Podfile que se creó e ingresa lo siguiente en la lista de frameworks:
    ```ruby
    platform :ios, '13.1'
    source 'https://github.com/grupo-profuturo/ios-framework-pod-spec'
    source 'https://github.com/CocoaPods/Specs.git'
    
    target 'ApplicationName' do

      use_frameworks!
      
      pod 'MAULibrary'

    end
    ```
4. Guarda el archivo y ejecuta la siguiente línea en la terminal:
    ```ruby
    pod update
    ```
    <b>NOTA:</b> Si utilizas macOS con algún procesador M1 y estás teniendo problemas con Cocoapods, asegúrate que utilizar Rosetta para los comandos, ya que hasta hoy (24 de febrero de 2021) aún no están migradas todas las bibliotecas del administrador de dependencias.



<!-- USAGE EXAMPLES -->

## Uso

Para el uso del Motor de Autenticación Universal, importa la siguiente biblioteca en tu archivo Swift:

```swift
import MAULibrary
```

Además, se necesitan agregar los siguientes atributos en el Info.plist:

```xml
<key>UIUserInterfaceStyle</key>
<string>Light</string>
<key>NSCameraUsageDescription</key>
<string>Profuturo requiere acceso a tu cámara para la captura de documentos</string>
<key>UIAppFonts</key>
	<array>
		<string>Roboto-Light.ttf</string>
		<string>Roboto-Medium.ttf</string>
		<string>Roboto-Regular.ttf</string>
		<string>OpenSans-Bold.ttf</string>
		<string>OpenSans-Light.ttf</string>
		<string>OpenSans-Regular.ttf</string>
	</array>
```

### Motor de Autenticación
Para iniciar con el proceso de autenticación, primero a nivel de clase se crea una instancia del objeto:

```swift
let mau = MAU()
```

En el viewDidLoad se define el delegate del objecto:

```swift
mau.delegate = self
```

Posteriormente, se agrega el delegate al ViewController:

```swift
//MARK: - AuthenticationMAUDelegate
extension ViewController: AuthenticationMAUDelegate {
    public func pushViewController<T>(viewController: T) {
        if let selectAuthenticationMethodVC = viewController as? SelectAuthenticationMethodViewController {
            navigationController?.pushViewController(selectAuthenticationMethodVC, animated: true)
        }
    }

    public func authentication(wasSuccesful: Bool) {
        //Your code here
    }
}
```

Por último, se ejecuta el motor de la siguiente manera, con el objeto de información requerido:

```swift
let userInformation = User.init(name: "", lastName: "", mothersLastName: "", client: "", account: "", curp: "", processID: 226, subProcessID: 405, originID: 34)
mau.startMAU(userInformation: userInformation)
```

<b>NOTA:</b> Este proceso se puede probar descargando la aplicación de prueba que viene en el proyecto y descargando las dependencias.

### Consumo de servicios
Para el consumo de servicios del MAU se utilizará la clase <b>APIConsumption</b>, esta se tiene que instanciar y llamar la función del servicio que se desea consumir (todas traen documentación explícita de lo que se pide y lo que se obtiene). A continuación se muestra un ejemplo de algunas funciones disponibles:

<p align="center"><img src="images/functions_api.png" alt="Functions" width="1060" height="230"></p>

Una vez que se seleccionó el servicio a consumir, se ingresan los parámetros y se utiliza el closure para obtener la información una vez que el servicio haya terminado de consultarse (Toda la información que se obtiene viene documentada en el código).

   ```swift
    APIConsumption.getUserProfile(of: "CURP", completion: (ProfileResponse?, Int) -> ())
   ```

   ```swift
    APIConsumption.getUserProfile(of: "CURP") { profileResponse, code in 
   		//Your code here
    }
   ```

## Autor
Ángel Eduardo Domínguez Delgado<br>
adomingd@everis.com