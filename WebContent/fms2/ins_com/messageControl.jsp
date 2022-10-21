<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page
	import="com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page
	import="java.util.*,java.io.*, acar.util.* ,acar.common.*, java.text.*, acar.user_mng.*"%>
<%@ page import="acar.beans.*, common.AttachedDatabase, acar.coolmsg.CdAlertBean"%>
<%@ page import="acar.coolmsg.CoolMsgDatabase, acar.kakao.AlimTalkDatabase,acar.common.CommonDataBase "%>
<%@ include file="/acar/cookies.jsp"%>


<%
	String regIdStr  = request.getParameter("regIdArr");	//�����  
	String carNoStr  = request.getParameter("carNoArr");	//������ȣ     
	
	 CoolMsgDatabase cm_db = CoolMsgDatabase.getInstance();
	 AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
     CommonDataBase user = CommonDataBase.getInstance();
     UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String regId ="";
	String carNo ="";
	
	String CompareId ="";
	
	String cont ="";
	boolean flag = false;
	
	String regIdArr[] = regIdStr.split(",");
	String carNoArr[] = carNoStr.split(",");

	String regIdTemp	= "";
	String carNoTemp	= "";
	
	if(regIdArr != null && carNoArr != null){
		
		//�޴� ����� ���� �������� ����
		for(int i=0; i< regIdArr.length-1; i++){
			for(int j = i; j <  regIdArr.length; j++){
				if(regIdArr[i].compareTo(regIdArr[j]) >0){
					regIdTemp = regIdArr[i];
					regIdArr[i] = regIdArr[j];
					regIdArr[j] = regIdTemp;
	
					carNoTemp = carNoArr[i];
					carNoArr[i] = carNoArr[j];
					carNoArr[j] = carNoTemp;
					
				}
			}		
		}
		for(int i=0; i<regIdArr.length; i++){
			//System.out.println("regId : "+ regIdArr[i]);
		}
		
		
		//�޴� ����� �̸����� �޼����� ���� �� �� ��, �Ѱ��� ������ ����
		for(int i=0; i<regIdArr.length; i++){
			regId = regIdArr[i];
			carNo = carNoArr[i];
			
			//���� ����Ʈ�� �޴»�� ��ȸ  
			if(i < regIdArr.length-1) CompareId=regIdArr[i+1]; 
						
	        cont= cont + (carNo+"������ ��û�� ���������� ��ϵǾ����ϴ�.\n");
	       // System.out.println(regId + " == " + CompareId);
	        
	      //�޴»���� �ٲ�ų� ������ ����Ʈ �� ��,
			if(!regId.equals(CompareId) || i == regIdArr.length-1 ){
				
				cont += "\n[���׺��� > ������� > ����������û��� ] �޴�����  [���� > �Ϸ�]���� �˻��Ͽ�"+
						"\n��� ���� �Է��� ����ó�� ���� �߼��Ͻñ� �ٶ��ϴ�."+
						"\n\n* �⺻������ ���ݰ�꼭 ���Ϸ� �߼�";
				
				Vector vt = user.getUserList(regId); 
        		// System.out.println( "�޴»��ID == " + regId);
	        	String target_id = "";
	          	String target_nm ="";
	        	String target_tel ="";
	        	
	        	//�޴� ����� ������ ������
	        	for(int j = 0 ; j < vt.size() ; j++){
	        		Hashtable ht = (Hashtable)vt.elementAt(j);	
	        		target_id = (String) ht.get("ID");
	        		target_nm = (String) ht.get("USER_NM");
	        		target_tel = (String) ht.get("USER_M_TEL");
	        		// System.out.println( "�޴»�� ��ȭ��ȣ == " + target_tel);
	        	}
	        	
	        	UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
	        	
	        	String title = "����������û���";
	        	/* String sender_id = "2017001";
	        	String sender_nm = "��ġ��";
	        	String sender_tel = "010-5680-9585"; */
	        	String sender_id = sender_bean.getId();
	        	String sender_nm = sender_bean.getUser_nm();
	        	String sender_tel = sender_bean.getUser_m_tel();
				
	        	
	        	String xml_data = "";
				xml_data =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
		  					"    <BACKIMG>4</BACKIMG>"+
		  					"    <MSGTYPE>104</MSGTYPE>"+
		  					"    <SUB>"+title+"</SUB>"+
			  				"    <CONT>"+cont+"</CONT>"+
		 					"    <URL></URL>";
				xml_data += "    <TARGET>"+target_id+"</TARGET>";
				xml_data += "    <SENDER>"+sender_id+"</SENDER>"+
		  					"    <MSGICON>10</MSGICON>"+
		  					"    <MSGSAVE>1</MSGSAVE>"+
		  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  				"    <FLDTYPE>1</FLDTYPE>"+
		  					"  </ALERTMSG>"+
		  					"</COOLMSG>"; 
	        	
				CdAlertBean msg = new CdAlertBean();
				msg.setFlddata(xml_data);
				msg.setFldtype("1"); 
				
				flag = cm_db.insertCoolMsg(msg);
				
				String at_cont      = "";
				at_cont += title+"\n\n" +
						   cont +"\n\n" +
						   "(��)�Ƹ���ī (www.amazoncar.co.kr)";
				
				//at_db.sendMessage(1009, "0", at_cont,target_tel,sender_tel , null, "", target_id);
				
	        	cont ="";
	        	
	        	
				/*
	        	List<String> fieldList = Arrays.asList(title, d_user_nm, d_user_tel, chief_nm, deceased_nm, d_day_st, place_nm, place_tel, place_addr);
				at_db.sendMessage(1009, "acar0121", fieldList, place_tel,  d_user_tel, null , "",  user_id) ;
				at_db.sendMessageReserve("acar0121", fieldList, place_tel, d_user_tel, null , "",  user_id);
	        	*/
				
			}
		}
						
	}
	
	
 
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
	<script>
	var flag= '<%=flag%>'
	if(flag){
		window.close();
	}
	</script>
</body>
</html>