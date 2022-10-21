<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page
	import="com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page
	import="java.util.*,java.io.*, acar.util.* ,acar.common.*, java.text.*, acar.user_mng.*"%>
<%@ page import="acar.beans.*, common.AttachedDatabase, acar.coolmsg.CdAlertBean"%>
<%@ page import="acar.coolmsg.CoolMsgDatabase, acar.kakao.AlimTalkDatabase,acar.common.CommonDataBase "%>
<%@ include file="/acar/cookies.jsp"%>


<%
	String regIdStr  = request.getParameter("regIdArr");	//등록자  
	String carNoStr  = request.getParameter("carNoArr");	//차량번호     
	
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
		
		//받는 사람에 대한 오름차순 정렬
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
		
		
		//받는 사람의 이름으로 메세지가 여러 개 일 때, 한개만 보내기 위함
		for(int i=0; i<regIdArr.length; i++){
			regId = regIdArr[i];
			carNo = carNoArr[i];
			
			//다음 리스트의 받는사람 조회  
			if(i < regIdArr.length-1) CompareId=regIdArr[i+1]; 
						
	        cont= cont + (carNo+"차량의 요청한 가입증명서가 등록되었습니다.\n");
	       // System.out.println(regId + " == " + CompareId);
	        
	      //받는사람이 바뀌거나 마지막 리스트 일 때,
			if(!regId.equals(CompareId) || i == regIdArr.length-1 ){
				
				cont += "\n[사고및보험 > 보험관리 > 가입증명서요청등록 ] 메뉴에서  [구분 > 완료]으로 검색하여"+
						"\n비고 란에 입력한 수신처는 직접 발송하시기 바랍니다."+
						"\n\n* 기본적으로 세금계산서 메일로 발송";
				
				Vector vt = user.getUserList(regId); 
        		// System.out.println( "받는사람ID == " + regId);
	        	String target_id = "";
	          	String target_nm ="";
	        	String target_tel ="";
	        	
	        	//받는 사람의 정보를 가져옴
	        	for(int j = 0 ; j < vt.size() ; j++){
	        		Hashtable ht = (Hashtable)vt.elementAt(j);	
	        		target_id = (String) ht.get("ID");
	        		target_nm = (String) ht.get("USER_NM");
	        		target_tel = (String) ht.get("USER_M_TEL");
	        		// System.out.println( "받는사람 전화번호 == " + target_tel);
	        	}
	        	
	        	UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
	        	
	        	String title = "가입증명서요청등록";
	        	/* String sender_id = "2017001";
	        	String sender_nm = "최치권";
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
						   "(주)아마존카 (www.amazoncar.co.kr)";
				
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