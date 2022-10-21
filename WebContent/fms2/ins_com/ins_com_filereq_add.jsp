<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, java.io.*, java.time.* ,java.text.SimpleDateFormat"%>
<%@ page import="acar.coolmsg.*"%>
<%@ page import="acar.insur.*,acar.user_mng.*,acar.car_sche.*"%>
<jsp:useBean id="cm_bean" scope="page" class="acar.car_mst.CarMstBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String chk[] = request.getParameterValues("chk")==null?null:request.getParameterValues("chk");
	
	InsComDatabase ic_db = InsComDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();

	Date now = new Date();
	SimpleDateFormat formatter = new SimpleDateFormat("HH");
	String formatedNow = formatter.format(now);
	
	int hour = Integer.parseInt(formatedNow);
	
	String car_mng_id ="";
	String ins_st ="";
	
	String temp[] = new String[3];
	int accid_size =0;
	
	Vector<Hashtable> vec = new Vector<Hashtable>();
	
	int result =0;
	String msg = "";
	String car_no="";
	String rent_l_cd="";
	String ins_com_nm="";
	
	int msgCount = 0;
	
	for(int i=0; i<chk.length; i++){
		temp = chk[i].split(",");
		
		car_mng_id = temp[0];
		ins_st = temp[1];
		rent_l_cd = temp[2];
		
		vec.addElement(ic_db.getInusrInfo(car_mng_id, ins_st, rent_l_cd));
	}
	
 	if(vec.size() > 0){
		
		InsurExcelBean ins = new InsurExcelBean();
		String reg_code  = Long.toString(System.currentTimeMillis());
		int count = 0;
		String gubun = "����";
		String use_st = "��û";
				
		for(int i = 0 ; i < vec.size() ; i++) {
		 	Hashtable ht = (Hashtable)vec.elementAt(i);
			
			ins.setReg_code(reg_code);
			ins.setSeq(count++);
			ins.setReg_id(ck_acar_id);
			ins.setReq_id(ck_acar_id);
			ins.setGubun(gubun);
			ins.setRent_mng_id(String.valueOf(ht.get("RENT_MNG_ID")));
			ins.setRent_l_cd(String.valueOf(ht.get("RENT_L_CD")));
			ins.setCar_mng_id(String.valueOf(ht.get("CAR_MNG_ID"))); 
			ins.setIns_st(String.valueOf(ht.get("INS_ST"))); 
			ins.setValue01(String.valueOf(ht.get("INS_CON_NO"))); 
			ins.setValue02(String.valueOf(ht.get("CAR_NO")));
			ins.setValue03(String.valueOf(ht.get("CAR_NUM")));
			ins.setValue04(String.valueOf(ht.get("INS_START_DT")));
			ins.setValue05(String.valueOf(ht.get("INS_EXP_DT")));
			ins.setValue06(String.valueOf(ht.get("FIRM_NM")));
			ins.setValue07(String.valueOf(ht.get("INS_STS")));
			ins.setValue08(String.valueOf(ht.get("CAR_NM")));
 			ins.setValue09(String.valueOf(ht.get("ENP_NO")));
			
			car_no=String.valueOf(ht.get("CAR_NO"));
			ins_com_nm = String.valueOf(ht.get("INS_COM_NM"));
			
			int check = 0;
			check = ic_db.getCheckOverInsExcelCom3(ins.getValue01(),ins.getValue04(),ins.getValue05(), ins.getValue06());
			
			int check2 = 0;
			check2 = ic_db.getCheckOverInsExcelCom4(ins.getValue01(),ins.getValue04());
			
			
			
			if(check > 0){
				result = 2;
				msg += car_no+"   ";
			}
			else if(check2 > 0){
				result = 3;
				msg += car_no+"   ";
			}			
			else{
				
				if(!ic_db.insertInsExcelCom2(ins)){
					result = 1;
				}else{
					result = 0;
				} 
				
				//�޼���������
				if(result == 0 && msgCount == 0){
					if(!String.valueOf(ht.get("INS_CON_NO")).startsWith("P")){
						UserMngDatabase um = UserMngDatabase.getInstance();
						UsersBean suser  = um.getUsersBean(ck_acar_id);
						String[] t_id = new String[1];
// 						if(	suser.getDept_nm().equals("������ȹ��")	 || suser.getDept_nm().equals("������")
// 							|| suser.getDept_nm().equals("��������")	|| suser.getDept_nm().equals("�ѹ���")
// 							|| suser.getDept_nm().equals("��������") || suser.getDept_nm().equals("��������") )
// 						{
// 							t_id[0] = "000048";//000277
// 						}else{
						// ���� 3�� ���Ŀ��� ���缮 �븮(000278)���� �߼� -> '�輺��' --000153
// 						System.out.println(hour);
						if(hour >= 14) {
							t_id[0] = "000153";
							CarScheBean cs_bean9 = csd.getCarScheTodayBean("000153");
							if(!cs_bean9.getWork_id().equals("")) {
								t_id[0] = "000130";
							}
						}
						else {
							t_id[0] = "000177";
							CarScheBean cs_bean7 = csd.getCarScheTodayBean("000177");
							// ����� ���α� ���(000177)�� �ް��� ��ü �ٹ��ڿ���
								if(!cs_bean7.getWork_id().equals("")){
									t_id[0] = cs_bean7.getWork_id();
									CarScheBean cs_bean8 = csd.getCarScheTodayBean(cs_bean7.getWork_id());
									// ��ü�ٹ��� �ް��� ���� �븮(000130)���� �߼�
									if(!cs_bean8.getWork_id().equals("")) {
										t_id[0] = "000130";
									}
								}
						}
// 						}
						
// 						System.out.println(t_id[0]);
						
						CdAlertBean msg2 = new CdAlertBean();
						CoolMsgDatabase cm_db = CoolMsgDatabase.getInstance();
						
						for(int j=0; j< t_id.length; j++){
							UsersBean tuser  = um.getUsersBean(t_id[j]);
							
							boolean flag=false;
							String target_id = tuser.getId();
				          	String target_nm = tuser.getUser_nm();
							
							String title = "����������û���";
				        	String sender_id = suser.getId();
				        	String sender_nm = suser.getUser_nm();
							
				        	String cont= sender_nm+" ����ڷ� ���� "+ins_com_nm+" ����������û�� ��ϵǾ����ϴ�.";
				        	String url = "http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url=/fms2/ins_com/ins_com_filereq_frame.jsp";
				        	
							String xml_data = "";
							xml_data =  "<COOLMSG>"+
						  				"<ALERTMSG>"+
					  					"    <BACKIMG>4</BACKIMG>"+
					  					"    <MSGTYPE>104</MSGTYPE>"+
					  					"    <SUB>"+title+"</SUB>"+
						  				"    <CONT>"+cont+"</CONT>"+
					 					"    <URL>"+url+"</URL>";
							xml_data += "    <TARGET>"+target_id+"</TARGET>";
							xml_data += "    <SENDER>"+sender_id+"</SENDER>"+
					  					"    <MSGICON>10</MSGICON>"+
					  					"    <MSGSAVE>1</MSGSAVE>"+
					  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
						  				"    <FLDTYPE>1</FLDTYPE>"+
					  					"  </ALERTMSG>"+
					  					"</COOLMSG>"; 
							
							msg2.setFlddata(xml_data);
							msg2.setFldtype("1"); 
							flag = cm_db.insertCoolMsg(msg2);
							msgCount++;
						}
					}
				}
				
			}
		}
	} 
%>

<html>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">

</head>
<script>
	var result = '<%=result%>';
	var car_no = '<%=car_no%>';
	
	if(result == 0){
		alert("����� �Ϸ� �Ǿ����ϴ�.");
		opener.parent.location.reload();
		self.close();
	}else if(result == 1){
		alert("����� �����Ͽ����ϴ�. �ٽ� �õ��� �ֽñ� �ٶ��ϴ�.");
		location.href = "search.jsp?t_wd="+car_no+"&s_kd=2";
	}else if(result == 2){
		var msg = '<%=msg%>';
		alert(msg+'\n\n�ش������� ������ �̹� ��û �ߴ� �����Դϴ�.\n�˻�â�� �ش������� �˻��� �ֽñ� �ٶ��ϴ�.');
		opener.parent.location.reload();
		self.close();
	}else if(result == 3){
		var msg = '<%=msg%>';
		alert(msg+'\n\n�̹� ��û�� �����Դϴ�. ������� > �������� > �˻� �� ����ڸ� Ȯ�� �� \n���Ϲ߼��Ͻñ� �ٶ��ϴ�.');
		opener.parent.location.reload();
		self.close();
	}
	
</script>


<body>

</body>

