<%@ page language="java" contentType="text/plain;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<%
//�����Һ� ���ڹ��� ��ȯ ������ .... ������ DesyEdit ���α׷� ��õ. FMS���� ������ TEXT�� ������� ���� Edit ���α׷����� ��� �� ù3���� ����� ����. ��ȣȭ ���α׷��� �Ἥ ������ ��ȣȭ ��Ų��.
response.setHeader("Content-Type", "text/plain");
response.setHeader("Content-Disposition", "attachment;filename="+AddUtil.ChangeString(AddUtil.getDate())+".401;");
String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
String gubun1 = request.getParameter("gubun1")==null?"13":request.getParameter("gubun1");
String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
String nb_dt = request.getParameter("nb_dt")==null?"":request.getParameter("nb_dt");
String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
String est_mon = request.getParameter("est_mon")==null?"":request.getParameter("est_mon");
String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");

String view_dt = "";
int total_su = 0;
long total_amt11 = 0;
long total_amt12 = 0;
long total_amt13 = 0;
long total_amt14 = 0;
long total_amt15 = 0;
long total_amt21 = 0;
long total_amt22 = 0;
long total_amt23 = 0;
long total_amt24 = 0;
long total_amt25 = 0;
long total_amt31 = 0;
long total_amt32 = 0;
long total_amt33 = 0;
long total_amt34 = 0;
long total_amt35 = 0;
long total_amt41 = 0;
long total_amt42 = 0;
long total_amt43 = 0;
long total_amt44 = 0;
long total_amt45 = 0;
String tax_rate1 = "";

Vector taxs1 = t_db.getTaxExcelList1_1(br_id, gubun1, gubun2, gubun3, "", gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, "3");
int tax_size1 = taxs1.size();
if(tax_size1 > 0){
for(int i = 0 ; i < tax_size1 ; i++){
Hashtable tax1 = (Hashtable)taxs1.elementAt(i);
total_amt11   = total_amt11 + Long.parseLong(String.valueOf(tax1.get("CAR_FS_AMT")));
total_amt12   = total_amt12 + Long.parseLong(String.valueOf(tax1.get("����ǥ��")));
total_amt13   = total_amt13 + Long.parseLong(String.valueOf(tax1.get("���ⰳ���Һ�")));
total_amt14   = total_amt14 + Long.parseLong(String.valueOf(tax1.get("���ⱳ����")));
total_amt15   = total_amt15 + Long.parseLong(String.valueOf(tax1.get("AMT")));
tax_rate1 = (String)tax1.get("TAX_RATE");
}}
Vector taxs2 = t_db.getTaxExcelList1_1(br_id, gubun1, gubun2, gubun3, "", gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, "2");
int tax_size2 = taxs2.size();
if(tax_size2 > 0){
for(int i = 0 ; i < tax_size2 ; i++){
Hashtable tax2 = (Hashtable)taxs2.elementAt(i);
total_amt21   = total_amt21 + Long.parseLong(String.valueOf(tax2.get("CAR_FS_AMT")));
total_amt22   = total_amt22 + Long.parseLong(String.valueOf(tax2.get("����ǥ��")));
total_amt23   = total_amt23 + Long.parseLong(String.valueOf(tax2.get("���ⰳ���Һ�")));
total_amt24   = total_amt24 + Long.parseLong(String.valueOf(tax2.get("���ⱳ����")));
total_amt25   = total_amt25 + Long.parseLong(String.valueOf(tax2.get("AMT")));
}}
Vector taxs3 = t_db.getTaxExcelList1_1(br_id, gubun1, gubun2, gubun3, "", gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, "1");
int tax_size3 = taxs3.size();
if(tax_size3 > 0){
for(int i = 0 ; i < tax_size3 ; i++){
Hashtable tax3 = (Hashtable)taxs3.elementAt(i);
total_amt31   = total_amt31 + Long.parseLong(String.valueOf(tax3.get("CAR_FS_AMT")));
total_amt32   = total_amt32 + Long.parseLong(String.valueOf(tax3.get("����ǥ��")));
total_amt33   = total_amt33 + Long.parseLong(String.valueOf(tax3.get("���ⰳ���Һ�")));
total_amt34   = total_amt34 + Long.parseLong(String.valueOf(tax3.get("���ⱳ����")));
total_amt35   = total_amt35 + Long.parseLong(String.valueOf(tax3.get("AMT")));
}}
Vector taxs4 = t_db.getTaxExcelList1_1(br_id, gubun1, gubun2, gubun3, "", gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, "4");
int tax_size4 = taxs4.size();
if(tax_size4 > 0){
for(int i = 0 ; i < tax_size4 ; i++){
Hashtable tax4 = (Hashtable)taxs4.elementAt(i);
total_amt41   = total_amt41 + Long.parseLong(String.valueOf(tax4.get("CAR_FS_AMT")));
total_amt42   = total_amt42 + Long.parseLong(String.valueOf(tax4.get("����ǥ��")));
total_amt43   = total_amt43 + Long.parseLong(String.valueOf(tax4.get("���ⰳ���Һ�")));
total_amt44   = total_amt44 + Long.parseLong(String.valueOf(tax4.get("���ⱳ����")));
total_amt45   = total_amt45 + Long.parseLong(String.valueOf(tax4.get("AMT")));

}}
String gsgg_dt = ""; //�����Ⱓ��� ex)201301
//�б⺰ �����Ⱓ ����
if(nb_dt.equals("04")){
	gsgg_dt = AddUtil.getDate(1)+nb_dt;
}else if(nb_dt.equals("07")){
	gsgg_dt = AddUtil.getDate(1)+nb_dt;
}else if(nb_dt.equals("10")){
	gsgg_dt = (AddUtil.parseInt(AddUtil.getDate(1))-1)+nb_dt;
}else if(nb_dt.equals("01")){
	gsgg_dt = AddUtil.getDate(1)+nb_dt;
}

//System.out.println("gsgg_dt: "+gsgg_dt);
//�����Һ� Header �κ�
out.print("10");								//�ڷᱸ�� : 10
out.print("S401");								//�����ڵ� : S401
out.print(AddUtil.rpad("1288147957",13," "));	//������ID : �Ƹ���ī ����ڵ�Ϲ�ȣ
out.print("47");								//���񱸺��ڵ� : 47
out.print("1");									//�Ű��� : 1
out.print("8");									//�����ۺ� : 8
out.print(AddUtil.getDate(5));					//������
out.print(gsgg_dt);					//�����Ⱓ���
out.print(AddUtil.rpad("amazoncar1",20," "));	//�����ID : amazoncar1
out.print(AddUtil.rpad("���μ�",27," "));			//�����븮�μ���
out.print("000131");							//�����븮�ΰ�����ȣ-user_id ����
out.print(AddUtil.rpad("07082248014",14," "));	//�����븮����ȭ��ȣ
out.print(AddUtil.rpad("(��)�Ƹ���ī",25," "));		//��ȣ(���θ�)
out.print(AddUtil.rpad("����� �������� ���ǵ��� 17-3 ��ȯ��� 8��",54," "));		//����������
out.print(AddUtil.rpad("027570802",14," "));						//�������ȭ��ȣ
out.print(AddUtil.rpad("������",27," "));								//����(��ǥ�ڸ�)
out.print(AddUtil.ChangeString(AddUtil.getDate()));					//�ۼ�����
out.print("9000");													//�������α׷��ڵ�(9000-��Ÿ)
out.print("0001");													//�Ű�����
out.print("0001");													//������ȣ
out.print(AddUtil.lpad(" ",31," "));								//����
out.print("\n");													//�����ٷ� �ѱ� enter ó��

//�����Һ� �Ű����
out.print("41");								//�ڷᱸ��
out.print("S401");								//�����ڵ�
out.print("47");								//���񱸺��ڵ�
out.print(gsgg_dt);								//�����Ⱓ���
out.print(AddUtil.rpad("1288147957",13," "));	//������ID 
out.print("1");									//�Ű���
out.print("0001");								//�Ű�����
out.print("0001");								//������ȣ
out.print("8");									//�����ڱ���
out.print(AddUtil.rpad("amazoncar1",20," "));		//�����ID
out.print("1156110019610");							//(�ֹ�)���ι�ȣ
out.print(AddUtil.ChangeString(AddUtil.getDate()));		//�Է�����
out.print(AddUtil.getDate(5));							//������
out.print(AddUtil.rpad("(��)�Ƹ���ī",25," "));				//��ȣ(���θ�)
out.print(AddUtil.rpad("������",27," "));					//����(��ǥ��)
out.print(AddUtil.rpad("����� �������� ���ǵ��� 17-3 ��ȯ��� 8��",54," "));	//����������
out.print(AddUtil.rpad("027570802",14," "));					//��ȭ��ȣ
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt13+total_amt23+total_amt33+total_amt43),15,"0"));	//�����Ҽ����հ�(�����Һ�)
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt14+total_amt24+total_amt34+total_amt44),15,"0"));	//�����Ҽ����հ�(������)
out.print(AddUtil.lpad("0",15,"0"));															//�����Ҽ����հ�(��Ư��)
out.print(AddUtil.lpad(" ",8," "));																//�������
out.print(AddUtil.lpad(" ",70," "));															//�������
out.print("N");																					//Ư�ʽ�û����ڿ��� = N
out.print(AddUtil.lpad(" ",98," "));															//����
out.print("\n");								//�����ٷ� �ѱ� enter ó��

//������ǰ����ǥ�ؽŰ� 51011, 50121 2000 �̻�, ���� 2���� �Ű�� ������ �հ���� �����ؼ� �� 4�ٷ� �ۼ�.
out.print("47");
out.print("S401");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print("51041");//51011
out.print("0000");
out.print(AddUtil.rpad("���Ǻθ鼼�뵵���ݽ¿���(2000CC�ʰ�)(18-1-3)",46," "));//�Ϲݽ¿��ڵ���(2000cc�ʰ�)51
out.print(AddUtil.lpad("�ڵ���",27," "));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt12),15,"0"));
out.print(AddUtil.lpad(tax_rate1,7,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt13),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt14),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt13),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt14),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",28," "));
out.print("\n");

//������ǰ����ǥ�ؽŰ� 51021 �κ�
out.print("47");
out.print("S401");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print("51042");//51021
out.print("0000");
out.print(AddUtil.rpad("���Ǻο뵵���ݽ¿���(2000CC����)(2011��ͼӺ���)18-1-3",43," "));//�Ϲݽ¿��ڵ���(2000cc����)
out.print(AddUtil.lpad("�ڵ���",27," "));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt22+total_amt32),15,"0"));
out.print("0000500");
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt23+total_amt33),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt24+total_amt34),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt23+total_amt33),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt24+total_amt34),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",28," "));
out.print("\n");

//������ǰ����ǥ�ؽŰ� 51045 �κ�
out.print("47");
out.print("S401");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print("51045");//51045
out.print("0000");
out.print(AddUtil.rpad("���Ǻθ鼼�뵵���� ���̺긮�� 2,000cc �ʰ�",44," "));//�Ϲݽ¿��ڵ���(2000cc�ʰ�)51
out.print(AddUtil.lpad("�ڵ���",27," "));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt42),15,"0"));
out.print(AddUtil.lpad(tax_rate1,7,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt43),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt44),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt43),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt44),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",28," "));
out.print("\n");

//������ǰ����ǥ�ؽŰ� 51041 �հ� �κ�
out.print("47");
out.print("S401");
out.print(AddUtil.rpad(" ",13," "));
out.print("99999");
out.print("51041");//51041
out.print("0000");
out.print(AddUtil.rpad("���Ǻθ鼼�뵵���ݽ¿���(2000CC�ʰ�)(18-1-3)",46," "));//�Ϲݽ¿��ڵ���(2000cc�ʰ�)51
out.print(AddUtil.lpad("�ڵ���",27," "));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt12),15,"0"));
out.print(AddUtil.lpad(tax_rate1,7,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt13),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt14),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt13),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt14),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",28," "));
out.print("\n");

//������ǰ����ǥ�ؽŰ� 51042 �հ� �κ�
out.print("47");
out.print("S401");
out.print(AddUtil.rpad(" ",13," "));
out.print("99999");
out.print("51042");//51042
out.print("0000");
out.print(AddUtil.rpad("���Ǻο뵵���ݽ¿���(2000CC����)(2011��ͼӺ���)18-1-3",43," "));//�Ϲݽ¿��ڵ���(2000cc����)51
out.print(AddUtil.lpad("�ڵ���",27," "));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt22+total_amt32),15,"0"));
out.print("0000500");
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt23+total_amt33),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt24+total_amt34),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt23+total_amt33),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt24+total_amt34),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",28," "));
out.print("\n");

//������ǰ����ǥ�ؽŰ� 51045 �հ� �κ�
out.print("47");
out.print("S401");
out.print(AddUtil.rpad(" ",13," "));
out.print("99999");
out.print("51045");//51045
out.print("0000");
out.print(AddUtil.rpad("���Ǻθ鼼�뵵���� ���̺긮�� 2,000cc �ʰ�",44," "));//���̺긮��(2000cc�ʰ�)
out.print(AddUtil.lpad("�ڵ���",27," "));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt42),15,"0"));
out.print(AddUtil.lpad(tax_rate1,7,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt43),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt44),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt43),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt44),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",28," "));
out.print("\n");

//������ǰ���Ǹ�(����)���� ���� -------------------------------------------------------------------------
if(tax_size1 > 0){
for(int i = 0 ; i < tax_size1 ; i++){
Hashtable tax1 = (Hashtable)taxs1.elementAt(i);
out.print("47");
out.print("S404");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print("51041");//51011
out.print("0000");
out.print(String.format("%06d", i+1));
out.print(AddUtil.getReplace_dt(String.valueOf(tax1.get("TAX_COME_DT")))); //out.print((String)(tax1.get("��������")));
out.print(AddUtil.rpad("���Ǻθ鼼�뵵���ݽ¿���(2000CC�ʰ�)(18-1-3)",46," "));//�Ϲݽ¿��ڵ���(2000cc�ʰ�)
out.print(AddUtil.rpad((String)(tax1.get("CAR_NO")),29," "));
out.print(AddUtil.rpad("0",30," "));
out.print(AddUtil.lpad("1",11,"0"));						//����
out.print(AddUtil.lpad((String)tax1.get("CAR_FS_AMT"),13,"0"));//�ܰ�
out.print(AddUtil.lpad((String)tax1.get("CAR_FS_AMT"),13,"0"));//���Ⱑ��
out.print(AddUtil.lpad((String)tax1.get("����ǥ��"),13,"0"));//����ǥ��(�����Һ�)
out.print(AddUtil.lpad((String)tax1.get("TAX_RATE"),7,"0"));
out.print(AddUtil.lpad((String)tax1.get("���ⰳ���Һ�"),13,"0"));
out.print(AddUtil.lpad((String)tax1.get("���ⱳ����"),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad((String)tax1.get("���ⰳ���Һ�"),13,"0"));
out.print(AddUtil.lpad((String)tax1.get("���ⱳ����"),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(" ",30," "));
out.print(AddUtil.lpad(" ",13," "));
out.print(AddUtil.lpad(" ",20," "));
out.print(AddUtil.getReplace_dt(String.valueOf(tax1.get("TAX_COME_DT"))));
out.print("N");
out.print((String)(tax1.get("INIT_REG_DT")));
out.print((String)(tax1.get("�뵵��������")));
out.print("1");
out.print(AddUtil.lpad((String)tax1.get("SUR_RATE"),4,"0"));
out.print(AddUtil.rpad((String)(tax1.get("CAR_NUM")),30," "));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",76," "));
out.print("\n");
}}
if(tax_size2 > 0){
for(int i = 0 ; i < tax_size2 ; i++){
Hashtable tax2 = (Hashtable)taxs2.elementAt(i);
out.print("47");
out.print("S404");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print("51042");//51021
out.print("0000");
out.print(String.format("%06d", tax_size1+i+1));
out.print(AddUtil.getReplace_dt(String.valueOf(tax2.get("TAX_COME_DT"))));//out.print((String)(tax2.get("��������")));
out.print(AddUtil.rpad("���Ǻο뵵���ݽ¿���(2000CC����)(2011��ͼӺ���)18-1-3",43," "));//�Ϲݽ¿��ڵ���(2000cc����)
out.print(AddUtil.rpad((String)(tax2.get("CAR_NO")),29," "));
out.print(AddUtil.rpad("0",30," "));
out.print(AddUtil.lpad("1",11,"0"));
out.print(AddUtil.lpad((String)tax2.get("CAR_FS_AMT"),13,"0"));
out.print(AddUtil.lpad((String)tax2.get("CAR_FS_AMT"),13,"0"));
out.print(AddUtil.lpad((String)tax2.get("����ǥ��"),13,"0"));
out.print(AddUtil.lpad((String)tax2.get("TAX_RATE"),7,"0"));
out.print(AddUtil.lpad((String)tax2.get("���ⰳ���Һ�"),13,"0"));
out.print(AddUtil.lpad((String)tax2.get("���ⱳ����"),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad((String)tax2.get("���ⰳ���Һ�"),13,"0"));
out.print(AddUtil.lpad((String)tax2.get("���ⱳ����"),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(" ",30," "));
out.print(AddUtil.lpad(" ",13," "));
out.print(AddUtil.lpad(" ",20," "));
out.print(AddUtil.getReplace_dt(String.valueOf(tax2.get("TAX_COME_DT"))));
out.print("N");
out.print((String)(tax2.get("INIT_REG_DT")));
out.print((String)(tax2.get("�뵵��������")));
out.print("1");
out.print(AddUtil.lpad((String)tax2.get("SUR_RATE"),4,"0"));
out.print(AddUtil.rpad((String)(tax2.get("CAR_NUM")),30," "));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",76," "));
out.print("\n");
}}
if(tax_size3 > 0){
for(int i = 0 ; i < tax_size3 ; i++){
Hashtable tax3 = (Hashtable)taxs3.elementAt(i);
out.print("47");
out.print("S404");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print("51042");//51021
out.print("0000");
out.print(String.format("%06d", tax_size2+tax_size1+i+1));
out.print(AddUtil.getReplace_dt(String.valueOf(tax3.get("TAX_COME_DT"))));//out.print((String)(tax3.get("��������")));
out.print(AddUtil.rpad("���Ǻο뵵���ݽ¿���(2000CC����)(2011��ͼӺ���)18-1-3",43," "));//�Ϲݽ¿��ڵ���(2000cc����)
out.print(AddUtil.rpad((String)(tax3.get("CAR_NO")),29," "));
out.print(AddUtil.rpad("0",30," "));
out.print(AddUtil.lpad("1",11,"0"));
out.print(AddUtil.lpad((String)tax3.get("CAR_FS_AMT"),13,"0"));
out.print(AddUtil.lpad((String)tax3.get("CAR_FS_AMT"),13,"0"));
out.print(AddUtil.lpad((String)tax3.get("����ǥ��"),13,"0"));
out.print(AddUtil.lpad((String)tax3.get("TAX_RATE"),7,"0"));
out.print(AddUtil.lpad((String)tax3.get("���ⰳ���Һ�"),13,"0"));
out.print(AddUtil.lpad((String)tax3.get("���ⱳ����"),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad((String)tax3.get("���ⰳ���Һ�"),13,"0"));
out.print(AddUtil.lpad((String)tax3.get("���ⱳ����"),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(" ",30," "));
out.print(AddUtil.lpad(" ",13," "));
out.print(AddUtil.lpad(" ",20," "));
out.print(AddUtil.getReplace_dt(String.valueOf(tax3.get("TAX_COME_DT"))));
out.print("N");
out.print((String)(tax3.get("INIT_REG_DT")));
out.print((String)(tax3.get("�뵵��������")));
out.print("1");
out.print(AddUtil.lpad((String)tax3.get("SUR_RATE"),4,"0"));
out.print(AddUtil.rpad((String)(tax3.get("CAR_NUM")),30," "));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",76," "));
out.print("\n");
}}
if(tax_size4 > 0){
for(int i = 0 ; i < tax_size4 ; i++){
Hashtable tax4 = (Hashtable)taxs4.elementAt(i);
out.print("47");
out.print("S404");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print("51045");//51045  6%/10000000
out.print("0000");
out.print(String.format("%06d", tax_size3+tax_size2+tax_size1+i+1));
out.print((String)(tax4.get("��������")));//out.print(AddUtil.getReplace_dt(String.valueOf(tax4.get("TAX_COME_DT"))));//
out.print(AddUtil.rpad("���Ǻθ鼼�뵵���� ���̺긮�� 2,000cc �ʰ�",44," "));//�Ϲݽ¿��ڵ���(2000cc�ʰ�)
out.print(AddUtil.rpad((String)(tax4.get("CAR_NO")),29," "));
out.print(AddUtil.rpad("0",30," "));
out.print(AddUtil.lpad("1",11,"0"));						//����
out.print(AddUtil.lpad((String)tax4.get("CAR_FS_AMT"),13,"0"));//�ܰ�
out.print(AddUtil.lpad((String)tax4.get("CAR_FS_AMT"),13,"0"));//���Ⱑ��
out.print(AddUtil.lpad((String)tax4.get("����ǥ��"),13,"0"));//����ǥ��(�����Һ�)
out.print(AddUtil.lpad((String)tax4.get("TAX_RATE"),7,"0"));
out.print(AddUtil.lpad((String)tax4.get("���ⰳ���Һ�"),13,"0"));
out.print(AddUtil.lpad((String)tax4.get("���ⱳ����"),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad((String)tax4.get("���ⰳ���Һ�"),13,"0"));
out.print(AddUtil.lpad((String)tax4.get("���ⱳ����"),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(" ",30," "));
out.print(AddUtil.lpad(" ",13," "));
out.print(AddUtil.lpad(" ",20," "));
out.print(AddUtil.getReplace_dt(String.valueOf(tax4.get("TAX_COME_DT"))));
out.print("N");
out.print((String)(tax4.get("INIT_REG_DT")));
out.print((String)(tax4.get("�뵵��������")));
out.print("1");
out.print(AddUtil.lpad((String)tax4.get("SUR_RATE"),4,"0"));
out.print(AddUtil.rpad((String)(tax4.get("CAR_NUM")),30," "));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",76," "));
out.print("\n");
}}
//������ǰ���Ǹ�(����)���� �� -------------------------------------------------------------------------

//������ǰ���Ǹ�(����)���� �հ�κ�  -------------------------------------------------------------------------
out.print("47");
out.print("S404");
out.print(AddUtil.rpad(" ",13," "));
out.print("99999");
out.print("99999");
out.print("9999");
out.print("000001");
out.print(AddUtil.ChangeString(AddUtil.getDate()));
out.print(AddUtil.rpad("�հ�",58," "));
out.print(AddUtil.rpad("�ڵ���",27," "));
out.print(AddUtil.rpad("��",29," "));
out.print(String.format("%011d", 1));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt12+total_amt22+total_amt32+total_amt42),13,"0"));
out.print("0000000");
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt13+total_amt23+total_amt33+total_amt43),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt14+total_amt24+total_amt34+total_amt44),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt13+total_amt23+total_amt33+total_amt43),13,"0"));
out.print(AddUtil.lpad(Util.parseDecimalLong2(total_amt14+total_amt24+total_amt34+total_amt44),13,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad(" ",30," "));
out.print(AddUtil.lpad(" ",13," "));
out.print(AddUtil.lpad(" ",20," "));
out.print(AddUtil.lpad(" ",8," "));
out.print("N");
out.print(AddUtil.lpad(" ",8," "));
out.print(AddUtil.lpad(" ",8," "));
out.print("0");
out.print("0000");
out.print(AddUtil.lpad(" ",30," "));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",76," "));
out.print("\n");

/*
//��ǰ���һ�Ȳǥ ���� ------------------------------
if(tax_size1 > 0){
for(int i = 0 ; i < tax_size1 ; i++){
Hashtable tax1 = (Hashtable)taxs1.elementAt(i);
out.print("47");
out.print("S405");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print(String.format("%06d", i+1));
out.print(AddUtil.rpad((String)(tax1.get("CAR_NO")),29," "));
out.print(AddUtil.rpad("0",30," "));
out.print("�� ");
out.print(AddUtil.lpad("1",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("1",13,"0"));
out.print(AddUtil.lpad("1",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("1",13,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("1",15,"0"));
out.print(AddUtil.lpad("0",15,"0"));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",37," "));
out.print("\n");
}}
if(tax_size2 > 0){
for(int i = 0 ; i < tax_size2 ; i++){
Hashtable tax2 = (Hashtable)taxs2.elementAt(i);
out.print("47");
out.print("S405");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print(String.format("%06d", tax_size1+i+1));
out.print(AddUtil.rpad((String)(tax2.get("CAR_NO")),29," "));
out.print(AddUtil.rpad("0",30," "));
out.print("�� ");
out.print(AddUtil.lpad("1",11,"0"));out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("1",13,"0"));out.print(AddUtil.lpad("1",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));out.print(AddUtil.lpad("1",13,"0"));
out.print(AddUtil.lpad("0",11,"0"));out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("1",15,"0"));out.print(AddUtil.lpad("0",15,"0"));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",37," "));
out.print("\n");
}}
if(tax_size3 > 0){
for(int i = 0 ; i < tax_size3 ; i++){
Hashtable tax3 = (Hashtable)taxs3.elementAt(i);
out.print("47");
out.print("S405");
out.print(AddUtil.rpad(" ",13," "));
out.print("00000");
out.print(String.format("%06d", tax_size2+tax_size1+i+1));
out.print(AddUtil.rpad((String)(tax3.get("CAR_NO")),29," "));
out.print(AddUtil.rpad("0",30," "));
out.print("�� ");
out.print(AddUtil.lpad("1",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("1",13,"0"));
out.print(AddUtil.lpad("1",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("1",13,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",11,"0"));
out.print(AddUtil.lpad("0",13,"0"));
out.print(AddUtil.lpad("1",15,"0"));
out.print(AddUtil.lpad("0",15,"0"));
out.print("0001");
out.print("0001");
out.print(AddUtil.lpad(" ",37," "));
out.print("\n");
}}
//��ǰ���һ�Ȳǥ  �� -------------------------------------------------------------------
*/
out.close();


%>
