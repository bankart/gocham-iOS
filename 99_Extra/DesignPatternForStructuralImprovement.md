> GoF 디자인 패턴! 이렇게 활용한다. - C++로 배우는 패턴의 이해와 활용 

# ch16. 구조 개선을 위한 디자인 패턴 정리

* 패턴들의 그 구조나 동작 형태가 비슷비슷해서 혼란스러운 이유
	* 패턴들을 클래스 구조나 객체들의 동작 형태만 기준으로 구분하려고 하기 때문
	* 클래스의 구조나 동작 형태를 결정하는 메커니즘이 상속이나 참조 또는 클래스의 멤머로 포함시키는 관계 등 몇 가지로 한정되기 때문.  
	* 따라서 각 패턴들의 용도 및 생성 동기를 기준으로 패턴들을 구분하는 것이 바람직함.


### Adapter와 Bridge 패턴의 비교, 요약

|             | Adapter 패턴 | Bridge 패턴     |
| ----------- | ------------ | -------------- |
| 공통점    <td colspan="2"> - 제3의 객체를 간접 접근하도록 함으로써 설계의 유연성을 높여줌<br>- 제3의 객체를 제공하는 인터페이스와는 다른 형태로 요청이 전달됨 |
| 차이점      | - 이미 존재하는 두 가지 형태의 인터페이스 간 불일치성을 해소해주는 것이 주목적<br> - 인터페이스의 구현 방법이나 독립적인 변경 가능성에 대해서는 신경쓰지 않음. 다만 서로 독립적으로 설계된 두 개의 클래스가 변경없이 같이 사용될 수 있는 방법에 초점을 둠 | - 인터페이스와 그것의 구현 모듈을 연결시켜주는 역할 수행<br> - Client에게는 동일한 인터페이스를 제공하면서 내부 구현은 지속적으로 변경, 발전시켜나가기 위한 목적으로 사용 |
| 주적용 시점 | 사후처리: 기존의 소프트웨어에 새로운 요구 사항이 주어져 애초에 연관성이 고려되지 않은 클래스들이 함께 동작하도록 할 때 주로 사용 | 사전처리: 애초 설계 시 동일 인터페이스에 대해 여러 구현 방법을 적용시키거나 인터페이스와 구현을 독립적으로 수정, 발전시키기 위해 주로 사용 |

### Composite와 Decorator 패턴의 비교, 요약

|             | Composite 패턴 | Decorator 패턴     |
| ----------- | ------------ | -------------- |
| 공통점    <td colspan="2"> 회귀적 구성 관계를 가지는 비슷한 클래스 구조 사용 |
| 차이점      | 여러 개의 관련된 객체들이 동일한 형태로 취급될 수 있도록 클래스들을 구조화 시키는데 중점을 둠 | 여러 기능들을 동적으로 추가, 삭제할 수 있도록 만들어 주는데 중점을 둠 |
| 기타 <td colspan="2"> - 두 가지 패턴이 동시에 사용되어 상호 보완적인 역할을 수행할 수도 있음.<br>- Composite 패턴 입장에서 해석하면 Decorator 및 그 하위 클래스가 Composite 클래스 객체를 구성하는 기본 객체들을 위한 클래스 역할을 수행하는 것임 <br> - Decorator 패턴 입장에서 해석하면 Composite 클래스가 Decorator 및 그 하위 클래스 객체에 의해 최종적으로 꾸며질 객의 클래스 역할을 수행하는 것임 |


### Decorator와 Proxy 패텀의 비교,요약 

|             | Decorator 패턴 | Proxy 패턴     |
| ----------- | ------------ | -------------- |
| 공통점    <td colspan="2"> - 어떤 객체에 대한 간접 접근 방식을 제공하거나 구현 시 Client로부터 주어진 요청을 다른 객체로 전달하기 위한 데이터 멤버를 가지는 등 비슷한 구조임<br>- Client에게 자신이 참조하고 있는 객체와 동일한 인터페이스 제공 |
| 차이점      | - 어떤 객체에게 기능이나 특성을 추가, 제거하는 것이 주목적<br> - 회귀적인 구성 관계를 가짐<br> - 클래스 추가 정의를 통해 새로운 기능의 정의가 가능함<br> - Decorator 객체가 수행하는 기능은 동적으로 확장될 수 있음 | - 어떤 객체를 간접 접근하거나 간접 접근 시 부가 처리를 수행하기 위한 방법 제공<br> - 주요 기능은 Subject 클래스에 의해 정의됨. Proxy 클래스는 부가적인 기능만 수행함<br> - 컴파일 시에 정적으로 Subject 클래스가 결정됨 |



