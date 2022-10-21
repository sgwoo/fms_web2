package acar.util;

import java.util.*; 
import java.io.*;
import java.net.*;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONObject;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
  
public class EmailSendApi {
	   
    public static String sendEmail(String emailAddr, String content) throws IOException {
    	
    	System.out.println("content >>>> " + content);    	
    	
    	/* ���� API ���� ������� ������ �̿� �Ͻñ� �ٶ��ϴ�. */

		// URL
		String url = "https://directsend.co.kr/index.php/api_v2/mail_change_word";

		java.net.URL obj;
		obj = new java.net.URL(url);
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();
		con.setRequestProperty("Cache-Control", "no-cache");
		con.setRequestProperty("Content-Type", "application/json;charset=utf-8");
		con.setRequestProperty("Accept", "application/json");

		/*
		 * subject  : ���� mail ����, ġȯ ���ڿ� ��� ����.
		 *   ġȯ ���ڿ� : [$NAME] - �̸�, [$EMAIL] - �̸���, [$MOBILE] - �޴���, [$NOTE] - ��� (�ѱ� 10���� /���� 30byte ó��)
		 * body  : ���� mail ����, ġȯ ���ڿ� ��� ����.
		 *   ġȯ ���ڿ� : [$NAME] - �̸�, [$EMAIL] - �̸���, [$MOBILE] - �޴���, [$NOTE] - ��� (�ѱ� 10���� /���� 30byte ó��)
		 * sender : �߼��� �����ּ�
		 * sender_name : �߼��� �̸� (40�� ����)
		 * username : directsend �߱� ID
		 * receiver : �߼� �� �� ������ ���� json array. ex) [{"name": "ȫ�浿", "email":"aaaa@directsend.co.kr", "mobile":"01012341234", "note1":"���̷�Ʈ���� 1"}, {"name": "ȫ�浿2", "email":"bbbb@directsend.co.kr", "mobile":"0101555123", "note1":"���̷�Ʈ���� 2"}]
		 * address_books : ����Ʈ�� ����� �߼� �� �ּҷ� ��ȣ , �� ������ (ex. 0,1,2)
		 * key : directsend �߱� api key
		 *
		 * �� ������ ��ȿ�������� ��쿡�� �߼��� ���� �ʽ��ϴ�.
		 * ��� ������ �ִ� ����(�ѱ� 10���� /���� 30byte ó��)�� �Ѵ� ��� �ִ� ���� ��ŭ �߷��� ġȯ �˴ϴ�.
		 * ����� ���� �����̳� ��ü ȫ�� ������ �߼��ϴ� ���, ���� (����) ������ ǥ���ؾ� �մϴ�.
		 * �������� �߼� ��, ������� ���� ���Ǹ� ���� �̿��Ը� ���� ���� �߼��� �����մϴ�.
		 * ���ŵ��� ���ο� ���� ������ �߻��ϴ� ��� �̿� ���� ����å���� ���� ���� �����ڿ��� �ֽ��ϴ�.
		 * �����ڰ� ���Űź� �Ǵ� ���ŵ��� öȸ �ǻ縦 ���� ǥ���� �� �ִ� �ȳ����� ����ؾ� �մϴ�.
		 * ���� ���� �߼� �뵵�� �ǿ��Ͻ� ��� �̿뿡 ������ ���� �� ������ �̿� �� ���� ��Ź �帳�ϴ�.
		 * �ҹ� ���� ���� �߼� �� ������� ���� �̿��� ������ �� ������ �̿����� �� �ش� ���̵��� �ּҷϰ� �ܾ��� �Ҹ�Ǹ�, ȯ�ҵ��� ������ ���� �̿뿡 ���Ǹ� ��Ź�帳�ϴ�.
		 *
		 * API ���� �߼۽� �ٷ��� �ּҸ� �ѹ��� �Է��Ͽ��� �����ڿ��Դ� 1:1�� ������ ������ ǥ��Ǹ�, ������ ������ ������ �ѰǾ� �߼��ϴ� �ͺ��� �ٷ����� �ѹ��� ������ ���� �߼� ȿ���� �� �����ϴ�.
		 * ������ ������ ������ �Ϻ� ���ڸ� �����Ͽ� �ټ����� �߼��Ͻô� ��� ������ ������ Json Array [{...}, {...}]�� �����Ͻþ� �ѹ��� �߼��Ͻô� ���� ���� �帳�ϴ�.
		 */

		// ���⼭���� �������ֽñ� �ٶ��ϴ�.

		//String subject = "[�׽�Ʈ] [$NAME]�� ȯ���մϴ�. ";   //�ʼ��Է�
		String subject = "[�׽�Ʈ]";   //�ʼ��Է�
		//String body = "[$NAME]�� ȯ���մϴ�. ġȯ ���� �Դϴ�. ���� �̸��� : [$EMAIL] ���Ź�ȣ : [$MOBILE] �޸� : [$NOTE]";                 //�ʼ��Է�
		String body = content;//�ʼ��Է�
		String sender = "dev@amazoncar.co.kr";        //�ʼ��Է�
		String sender_name = "amazoncar";
		String username = "amazoncar";              //�ʼ��Է� 
		String key = "Kq9kLODCrJYbbrf";           //�ʼ��Է� 

		//������ ���� �߰� - �ʼ� �Է�(�ּҷ� �̻���), ġȯ���� �̻��� ġȯ���� �����͸� �Է����� �ʰ� ����Ҽ� �ֽ��ϴ�.
		//ġȯ���� �̻��� {\"email\":\"aaaa@naver.com\"} �̸��ϸ� �Է� ���ֽñ� �ٶ��ϴ�.
		/*String receiver = "{\"name\": \"���浿\", \"email\":\"test1@directsend.co.kr\", \"mobile\":\"\", \"note1\":\"\"}"
			+ ",{\"name\": \"ȫ�浿\", \"email\":\"test2@directsend.co.kr\", \"mobile\":\"01012341234\", \"note1\":\"���̷�Ʈ ���� 1\"}"
			+ ",{\"name\": \"��浿\", \"email\":\"test3@directsend.co.kr\", \"mobile\":\"01023452345\", \"note1\":\"���̷�Ʈ ���� 2\"}"
			+ ",{\"name\": \"\", \"email\":\"test4@directsend.co.kr\", \"mobile\":\"01012341234\", \"note1\":\"\"}"
			+ ", {\"name\": \"�ڱ浿\", \"email\":\"test4@directsend.co.kr\", \"mobile\":\"\", \"note1\":\"API ���� �߼۽� �ٷ��� �ּҸ� �ѹ��� �Է��Ͽ��� �����ڿ��Դ� 1:1�� ������ ������ ǥ��Ǹ�, ������ ������ ������ �ѰǾ� �߼��ϴ� �ͺ��� �ٷ����� �ѹ��� ������ ���� �߼� ȿ���� �� �����ϴ�.\"}"
			;*/
		
		//String receiver = "{\"name\": \"���浿\", \"email\":\"test1@naver.com\", \"mobile\":\"\", \"note1\":\"\"}";
		String receiver = "{\"email\":\""+emailAddr+"\"}";

		receiver = "["+ receiver +"]";

		// �ּҷ��� ����ϱ� ���Ͻ� ��� �Ʒ� �ּ��� �����Ͻ� ��, ����Ʈ�� ����� �ּҷ� ��ȣ�� �Է����ֽñ� �ٶ��ϴ�.
		//String address_books = "0,1,2";      //�߼� �� �ּҷ� ��ȣ , �� ������ (ex. 0, 1, 2)

		// ���� �߼ۼ������� ���θ� �ޱ� ���Ͻ� ��� �Ʒ� �ּ��� �����Ͻ� ��, ����Ʈ�� ����� URL ��ȣ�� �Է����ֽñ� �ٶ��ϴ�.
		int return_url = 0;

		//open, click ���� ����� �ޱ� ���Ͻ� ��� �Ʒ� �ּ��� �����Ͻ� ��, ����Ʈ�� ����� URL ��ȣ�� �Է����ֽñ� �ٶ��ϴ�.
		//��ϵ� �������� http://domain �� ���� ���, http://domain?type=[click | open | reject]&mail_id=[MailID]&email=[Email] �� ���� �������� request�� �����帳�ϴ�.
		int option_return_url = 0;

		int open = 1;	// open ����� �������� �Ʒ� �ּ��� ���� ���ֽñ� �ٶ��ϴ�.
		int click = 1;	// click ����� �������� �Ʒ� �ּ��� ���� ���ֽñ� �ٶ��ϴ�.
		int check_period = 3;	// Ʈ��ŷ �Ⱓ�� �����ϸ� 3 / 7 / 10 / 15 ���� �������� �����Ͽ� �߼��� �ֽñ� �ٶ��ϴ�. (��, ������ ���� ���� ��� ����� ���� �� �����ϴ�.)

		// ����߼� ���� �߰�
		String mail_type = "NORMAL"; // NORMAL - ��ù߼� / ONETIME - 1ȸ���� / WEEKLY - �������⿹�� / MONTHLY - �ſ����⿹��
		String start_reserve_time = "2019-03-08 12:11:00";// �߼��ϰ��� �ϴ� �ð�
		String end_reserve_time = "2019-03-08 12:11:00";// �߼��� ������ �ð� 1ȸ ������ ��� start_reserve_time = end_reserve_time
		// WEEKLY | MONTHLY �� ��쿡 ���� �ð����� ������ �ð����� �߼۵Ǵ� Ƚ�� Ex) type = WEEKLY, start_reserve_time = '2017-05-17 13:00:00', end_reserve_time = '2017-05-24 13:00:00' �̸� remained_count = 2 �� �Ǿ�� �մϴ�.
		int remained_count = 1;
		// ���� ����/��� API�� �ҽ� �ϴ��� ���� ���ֽñ� �ٶ��ϴ�.

		//�ʼ��ȳ����� �߰�
		//String agreement_text = "�������� [$NOW_DATE] ����, ȸ������ ���ŵ��� ���θ� Ȯ���� ��� ȸ���Բ��� ���ŵ��Ǹ� �ϼ̱⿡ �߼۵Ǿ����ϴ�.";
		//String deny_text = "���� ������ ��ġ �����ø� [$DENY_LINK]�� Ŭ���ϼ���. \\nIf you don't want this type of information or e-mail, please click the [$EN_DENY_LINK]";
		//String sender_info_text = "����� ��Ϲ�ȣ:-- ������:������(��) ������(��) ������ ���������� TEL:-- \\nEmail: <a href='mailto:test@directsend.co.kr'>test@directsend.co.kr</a>";
		//int logo_state = 1; // logo ���� 1 / ������ �� 0
		//String logo_path = "http://logoimage.com/image.png';  //����Ͻ� �ΰ� �̹����� �Է��Ͻñ� �ٶ��ϴ�.";

		// ÷�������� URL�� ������ DirectSend���� ������ download �޾� �߼�ó���� �����մϴ�. ÷�������� ��ü 10MB ���Ϸ� �߼��� �ؾ� �ϸ�, ������ �����ڴ� '|(shift+\)'�� ����ϸ� 5�������� ÷�ΰ� �����մϴ�.
		String file_url = "https://directsend.co.kr/test.png|https://directsend.co.kr/test1.png";
		// ÷�������� �̸��� ������ �� �ֵ��� �մϴ�.
		// ÷�������� �̸��� ������(https://directsend.co.kr/test.png - image.png, https://directsend.co.kr/test1.png - image2.png) �� ���� ������ �Ǹ�, file_name�� �������� ���� ��� �������� ������ �̸����� ���Ͽ� �������ϴ�.
		String file_name = "image.png|image2.png";

		int bodytag = 1;  //HTML�� �⺻�� �Դϴ�. ���� ������ �ؽ�Ʈ�� ������ ��� �ּ��� ���� ���ֽñ� �ٶ��ϴ�.

		/* ������� �������ֽñ� �ٶ��ϴ�. */

		String urlParameters = "\"subject\":\"" + subject + "\" "
			+ ", \"body\":\"" + body + "\" "
			+ ", \"sender\":\"" + sender + "\" "
			+ ", \"sender_name\":\"" + sender_name + "\" "
			+ ", \"username\":\"" + username + "\" "
			+ ", \"receiver\":" + receiver
			//+ ", \"address_books\":\"" + address_books + "\" " 

			// ���� ���� �Ķ���� �ּ� ����
			//+ ", \"mail_type\":\"" + mail_type + "\" "
			//+ ", \"start_reserve_time\":\"" + start_reserve_time + "\" "
			//+ ", \"end_reserve_time\":\"" + end_reserve_time + "\" "
			//+ ", \"remained_count\":\"" + remained_count + "\" "

			// �ʼ� �ȳ����� ���� �Ķ���� �ּ� ����
			//+ ", \"agreement_text\":\"" + agreement_text + "\" "
			//+ ", \"deny_text\":\"" + deny_text + "\" "
			//+ ", \"sender_info_text\":\"" + sender_info_text + "\" "
			//+ ", \"logo_path\":\"" + logo_path + "\" "
			//+ ", \"logo_state\":\"" + logo_state + "\" "

			// ���� �߼۰���� �ް� ���� URL     return_url�� �ִ� ��� �ּ����� �ٶ��ϴ�.
			//+ ", \"return_url_yn\": " + true        //return_url ���� �ʼ� �Է�		
			//+ ", \"return_url\":\"" + return_url + "\" "		    //return_url ���� �ʼ� �Է�

			// �߼� ��� ���� �׸��� ����� ��� �ּ� ����
			//+ ", \"open\":\"" + open + "\" "
			//+ ", \"click\":\"" + click + "\" "
			//+ ", \"check_period\":\"" + check_period + "\" "
			//+ ", \"option_return_url\":\"" + option_return_url + "\" "

			// ÷�� ������ �ִ� ��� �ּ� ����
			//+ ", \"file_url\":\"" + file_url + "\" "
			//+ ", \"file_name\":\"" + file_name + "\" "

			// ���� ���� �ؽ�Ʈ�� ������ ��� �ּ� ����
			//+ ", \"bodytag\":\"" + bodytag + "\" "
				
			+ ", \"key\":\"" + key + "\" ";
		urlParameters = "{"+ urlParameters  +"}";		//JSON ������
		
		
		System.out.println("urlParameters >>>> " + urlParameters);



		System.setProperty("jsse.enableSNIExtension", "false");
		con.setDoOutput(true);
		OutputStreamWriter  wr = new OutputStreamWriter (con.getOutputStream());
		wr.write(urlParameters);
		wr.flush();
		wr.close();

		int responseCode = con.getResponseCode();
		System.out.println(responseCode);

		/*
		* responseCode �� 200 �� �ƴϸ� ���ο��� ������ �߻��� ���̽��Դϴ�.
		* directsend �����ڿ��� �������ֽñ� �ٶ��ϴ�.
		*/

		java.io.BufferedReader in = new java.io.BufferedReader(
			new java.io.InputStreamReader(con.getInputStream(), "UTF-8"));
		String inputLine;
		StringBuffer response = new StringBuffer();

		while ((inputLine = in.readLine()) != null) {
			response.append(inputLine);
			System.out.println("inputLine >>> " + inputLine);
		}

		in.close();

		System.out.println(response.toString());
		
		return response.toString();

		/*
		  * response�� ����
		  * {"status":101, "msg":"UTF-8 ���ڵ��� �ƴմϴ�."}
		  * ���� �ڵ��ȣ, ����
		*/

		/*
		  * response ����
		  * {"status":0}
		  * ���� �ڵ��ȣ
		  *
		  * �߸��� �̸��� �ּҰ� ���Ե� ���
		  * {"status":0, "msg":"��ȿ���� �ʴ� �̸����� �����ϰ� �߼� �Ϸ� �Ͽ����ϴ�.", "msg_detail":"error email : test2@test2, test3@test"}
		  * ���� �ڵ��ȣ, ����, �߸��� ������
		  *
		*/

		/*
			status code
			0   : ����߼�
			100 : POST validation ����
			101 : ȸ�������� ��ġ���� ����
			102 : Subject, Body ������ �����ϴ�.
			103 : Sender �̸����� ��ȿ���� �ʽ��ϴ�.
			104 : receiver �̸����� ��ȿ���� �ʽ��ϴ�.
			105 : ������ ���ԵǸ� �ȵǴ� Ȯ���ڰ� �ֽ��ϴ�.
			106 : body validation ����
			107 : �޴»���� �����ϴ�.
			108 : ���������� ��ȿ���� �ʽ��ϴ�.
			109 : return_url�� �����ϴ�.
			110 : ÷�������� �����ϴ�.
			111 : ÷�������� ������ 5���� �ʰ��մϴ�.
			112 : ������ ��Size�� 10 MB�� �Ѿ�ϴ�.
			113 : ÷�������� �ٿ�ε� ���� �ʾҽ��ϴ�.
			114 : utf-8 ���ڵ� ���� �߻�
			200 : ���� ����ð����δ� 200ȸ �̻� �߼��� �� �����ϴ�.
			201 : �д� 300ȸ �̻� �߼��� �� �����ϴ�.
			202 : �߼��ڸ��� �ִ���̸� �ʰ� �Ͽ����ϴ�.
			205 : �ܾ׺���
			999 : Internal Error.
		 */

		/* ���� API ���� ������� ������ �̿� �Ͻñ� �ٶ��ϴ�. */

		/* ====================================== ���� ��� API ���� ====================================== */
		/*
		 * ���� ��� ��ȸ API
		 * username : directsend �߱� ID
		 * key : directsend �߱� api key
		 *
		 * ������ ��ȸ -> ���� ��ȣ Ȯ�� -> ���� ����/���� ��� -> ���� ��� ��ȸ(�������� Ȯ��)
		 * �����ȣ, ���Ϲ�ȣ�� ���������� ��ȸ�ϱ� ���� API �Դϴ�.
		 * ���� ����� ��ȸ�Ͽ� JSON �������� ���� �˴ϴ�.
		 * JSON���� POST������ ���� �ؾ� �˴ϴ�.
		 * ���� ��� API ���� �ּ� ������ ��� �Ͻñ� �ٶ��ϴ�.
		*/

		/* ���⼭���� �������ֽñ� �ٶ��ϴ�. */

		//String username = "DirectSend id";                //�ʼ��Է�
		//String key = "DirectSend �߱� api key";           //�ʼ��Է�

		/* ������� �������ֽñ� �ٶ��ϴ�. */

		//String postvars = "{\"username\":\""+ username +"\",\"key\":\""+ key +"\"}";		//JSON ������

		//String url = "https://directsend.co.kr/index.php/api_mail_reserve/get";        //URL

		//java.net.URL obj;
		//obj = new java.net.URL(url);
		//HttpURLConnection con = (HttpURLConnection) obj.openConnection();
		//con.setRequestProperty("Cache-Control", "no-cache");
		//con.setRequestProperty("Content-Type", "application/json;charset=utf-8");
		//con.setRequestProperty("Accept", "application/json");

		//System.setProperty("jsse.enableSNIExtension", "false");
		//con.setDoOutput(true);
		//OutputStreamWriter  wr = new OutputStreamWriter (con.getOutputStream());
		//wr.write(postvars);
		//wr.flush();
		//wr.close();

		//int responseCode = con.getResponseCode();
		//System.out.println(responseCode);

		/*
		* responseCode �� 200 �� �ƴϸ� ���ο��� ������ �߻��� ���̽��Դϴ�.
		* directsend �����ڿ��� �������ֽñ� �ٶ��ϴ�.
		*/

		//java.io.BufferedReader in = new java.io.BufferedReader(
		//	new java.io.InputStreamReader(con.getInputStream()));
		//String inputLine;
		//StringBuffer response = new StringBuffer();

		//while ((inputLine = in.readLine()) != null) {
		//	response.append(inputLine);
		//}

		//in.close();

		//System.out.println(response.toString());

		/*
		 * response ���� json ������ ���
		 * {result:1, message:"success", data:{~~}}
		 *   data:total_count ���� ��� ��ü ����
		 *   data:list[~~]  ���� ��� ����
		 *      ��ȣ	mail_reserve_no
		 *      �߻��ѰǼ�	mail_reserve_count
		 *      �����	mail_reserve_date
		 *      �߼۽�����	mail_reserve_startdate
		 *      �߼�������	mail_reserve_enddate
		 *      ��������	mail_reserve_type       1 : 1ȸ / 2 : ���� / 3 : �Ŵ�
		 *      �߼� �� �Ǽ�	mail_send_count
		 *      �߼��� �̸���	mail_sender_email
		 *      ���� ����	mail_subject
		 *      ��������	mail_reserve_auth_flag      0 : ������ / 1 : ����
		 *      ���� ��ȣ	mail_no
		 */

		/*
		 * response ���� json ������ ���
		 * {result:100-1, message:���� ����}
		 */

		/*
			status code
			1 : ����
			100-1 : �Ķ���� ����
			100-2 : ���� ��� ��ȸ ����
		 */
		/* ====================================== ���� ��� API �� ====================================== */

		/* ====================================== ���� ����/��� API ���� ====================================== */
		/*
		 * ���� ����/��� API
		 * username : directsend �߱� ID
		 * key : directsend �߱� api key
		 * reserve_no : directsend ���� ��ȣ
		 * mail_no : directsend ���� ��ȣ
		 * reserve_type : ���� ����, ���� ���� API ���� �ʼ� �Է�
		 * mail_reserve_startdate : �߼��ϰ��� �ϴ� �ð�(��,�д��������� ����), ���� ���� API ���� �ʼ� �Է�
		 * mail_reserve_enddate : �߼��� ������ �ð�, ���� ���� API ���� �ʼ� �Է�
		 *
		 * ���� ����/��� API���� ��� �ϴ� �����ȣ, ���Ϲ�ȣ�� ���� ��� API�� ���Ͽ� Ȯ���Ͻ� �� �ֽ��ϴ�.
		 * ���� ����� ��ȸ�Ͽ� ���� ����/��� ������ JSON �������� ���� �ؾ� �˴ϴ�.
		 * ���� API ���� �ּ� ������ ��� �Ͻñ� �ٶ��ϴ�.		
		*/

		/* ���⼭���� �������ֽñ� �ٶ��ϴ�. */

		//String username = "DirectSend id";                //�ʼ��Է�
		//String key = "DirectSend �߱� api key";           //�ʼ��Է�
		//String reserve_no = "DirectSend �����ȣ";                   //���� ��ȣ (������ ��ȸ API�� ����Ͽ� Ȯ��), �ʼ��Է�
		//String mail_no = "DirectSend ���� ��ȣ";                      //���� ��ȣ (������ ��ȸ API�� ����Ͽ� Ȯ��), �ʼ��Է�

		// ���� ���� API ���� �ּ�����
		//String reserve_type = "1";		//�ʼ��Է�  1 : 1ȸ / 2 : ���� / 3 : �Ŵ�
		//String mail_reserve_startdate = "2019-05-11 12:11:00";// �߼��ϰ��� �ϴ� �ð�
		//String mail_reserve_enddate = "2019-05-11 12:11:00";// �߼��� ������ �ð� 1ȸ ������ ��� mail_reserve_startdate = mail_reserve_enddate

		/* ������� �������ֽñ� �ٶ��ϴ�. */

		//String postvars = "\"username\":\""+ username + "\""
		//	+",\"key\":\""+ key +"\"" 
		//	+",\"reserve_no\":\""+ reserve_no +"\""
		//	+",\"mail_no\":\""+ mail_no +"\""
		//	+",\"reserve_type\":\""+ reserve_type +"\""
		//	+",\"mail_reserve_startdate\":\""+ mail_reserve_startdate +"\""
		//	+",\"mail_reserve_enddate\":\""+ mail_reserve_enddate +"\""
		//;
		//postvars = "{"+ postvars +"}";

		//String url = "";

		//���� ���� API ���� �ּ� ����
		//url = "https://directsend.co.kr/index.php/api_mail_reserve/put";        //URL

		//���� ��� API ���� �ּ� ����
		//url = "https://directsend.co.kr/index.php/api_mail_reserve/delete";        //URL

		//java.net.URL obj;
		//obj = new java.net.URL(url);
		//HttpURLConnection con = (HttpURLConnection) obj.openConnection();
		//con.setRequestProperty("Cache-Control", "no-cache");
		//con.setRequestProperty("Content-Type", "application/json;charset=utf-8");
		//con.setRequestProperty("Accept", "application/json");

		//System.setProperty("jsse.enableSNIExtension", "false");
		//con.setDoOutput(true);
		//OutputStreamWriter  wr = new OutputStreamWriter (con.getOutputStream());
		//wr.write(postvars);
		//wr.flush();
		//wr.close();

		//int responseCode = con.getResponseCode();
		//System.out.println(responseCode);

		/*
		* responseCode �� 200 �� �ƴϸ� ���ο��� ������ �߻��� ���̽��Դϴ�.
		* directsend �����ڿ��� �������ֽñ� �ٶ��ϴ�.
		*/

		//java.io.BufferedReader in = new java.io.BufferedReader(
		//	new java.io.InputStreamReader(con.getInputStream()));
		//String inputLine;
		//StringBuffer response = new StringBuffer();

		//while ((inputLine = in.readLine()) != null) {
		//	response.append(inputLine);
		//}

		//in.close();

		//System.out.println(response.toString());

		/*
		 * response ���� json ������ ���
		 * {result:1, message:success}
		 */

		/*
		 * response ���� json ������ ���
		 * {result:100-1, message:���� ����}
		 */

		/*
			status code
			1 : ����
			100-3 : ���� ���� ����
			100-4 : ���� ���� ó�� ����
			100-5 : ���� ��� ó�� ����
		 */
		/* ====================================== ���� ����/��� API �� ====================================== */

    	
    }
}