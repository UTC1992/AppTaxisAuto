import 'package:flutter/material.dart';

class Perfil extends StatefulWidget {
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Flex(
        direction: Axis.vertical,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/editarNombre');
                  },
                  child: Row(
                    children: [
                      Icon(Icons.account_circle, color: Colors.grey[600]),
                      Expanded(
                        child: ListTile(
                          title: Text('Editar nombre'),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey[500])
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: GestureDetector(
                  onTap: () {
                    
                  },
                  child: Row(
                    children: [
                      Icon(Icons.photo, color: Colors.grey[600]),
                      Expanded(
                        child: ListTile(
                          title: Text('Editar imagen'),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[500],
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(Icons.email, color: Colors.grey[600]),
                      Expanded(
                        child: ListTile(
                          title: Text('Editar correo'),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey[500])
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(Icons.lock, color: Colors.grey[600]),
                      Expanded(
                        child: ListTile(
                          title: Text('Editar contraseña'),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey[500])
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(Icons.phone, color: Colors.grey[600]),
                      Expanded(
                        child: ListTile(
                          title: Text('Editar teléfono'),
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey[500])
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
