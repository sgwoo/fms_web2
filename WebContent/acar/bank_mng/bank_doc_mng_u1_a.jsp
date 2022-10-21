<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.coolmsg.*,  acar.user_mng.*, acar.cont.* "%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>

<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String yn = request.getParameter("yn")==null?"":request.getParameter("yn");
	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String cms_code = request.getParameter("cms_code")==null?"":request.getParameter("cms_code");
	String app_dt = request.getParameter("app_dt")==null?"":request.getParameter("app_dt");	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
%>

<%
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	int count = 0;
	boolean flag = true;	
	
	if (gubun.equals("2"))	{
		if ( gov_id.equals("0046")) { //우리카드인 셩우 할수 승인일 처리 
			flag = FineDocDb.updateFineDoc(doc_id, "app_dt", app_dt);  //카드할부인 경우 승인일	
		}
		
		if ( gov_id.equals("0011")) { //현대캐피탈 대출건 20220621  
			
			//getFineDocLists_sc
			Vector vt = FineDocDb.getFineDocLists_sc(doc_id);
		//	Vector vt = FineDocDb.getFineDocLists(doc_id);
			int vt_size = vt.size();
			
			for(int i = 0 ; i < vt_size ; i++){
			
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
					
				//출고정보
				ContPurBean pur = a_db.getContPur(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")));
				int trf_amt 	= pur.getTrf_amt1();  //대출금 
				
		//		System.out.println("rent_l_cd = " + String.valueOf(ht.get("RENT_L_CD")) + " trf_amt=" + trf_amt);
			
			//	if (String.valueOf(ht.get("RENT_L_CD")).equals("S122KK8R00138")) {
					flag = FineDocDb.updateFineDocList(doc_id, String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")), trf_amt);  //카드할부인 경우 승인일	(대출금 amt4)				
					flag = FineDocDb.updateFineDocList(doc_id, String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")), trf_amt/2, "amt6"); //담보수정
			//	}
			}
			
			
		}
	}	
	if (gubun.equals("1"))	{
		flag = FineDocDb.updateFineDoc(doc_id, "cms_code" , cms_code);
		
		// allot 기관코드 반영
		flag = FineDocDb.updateFineDocListAllot(doc_id, cms_code);	
		
		//대출신청 cms 모계좌가 틀린 경우 - 메세지 전송
		
		Vector vt = FineDocDb.getMemberCmsList(doc_id);
		int vt_size = vt.size();
		
		boolean flag2 = true;
		
		String sub 	= "CMS 당사 모계좌 확인요청";
		String cont   = "";
									
		    //담당자에게 메세지 전송------ 내용이 많아서 로그로 전달------------------------------------------------------------------------------------							
		UsersBean sender_bean 	= umd.getUsersBean("999999");
						
		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
						
					
				cont +=  "▣ 계약번호 "+ String.valueOf(ht.get("RENT_L_CD"))+"의  출금일 "+  String.valueOf(ht.get("CMS_START_DT"))  + "  모계좌 확인 ."+String.valueOf(ht.get("CMS_CODE")) + "로 등록요망 \n "   ;  	
					
		}												
					
		String url 		= "";				
							
		url 		= "/fms2/cms/master_cms_reg.jsp";		 
		
			String target_id =nm_db.getWorkAuthUser("CMS관리"); 	   // "000131"; //계산서 담당자		//000113->000058->권명숙(000131) -> 000129(송인숙)
		//	String target_id ="000212"; 	   // "000131"; //계산서 담당자		//000113->000058->권명숙(000131) -> 000129(송인숙)
					
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"    <BACKIMG>4</BACKIMG>"+
		  				"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
		 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
			
		//	xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			xml_data += "    <TARGET>2006007</TARGET>";
			
			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
		  				"    <MSGICON>10</MSGICON>"+
		  				"    <MSGSAVE>1</MSGSAVE>"+
		  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
		  				"  </ALERTMSG>"+
		  				"</COOLMSG>";
			
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");
					
	//		flag2 = cm_db.insertCoolMsg(msg);												
			System.out.println("쿨메신저(CMS 당사 모계좌 확인요청) "+cms_code ) ;
			System.out.println(cont ) ;
			
	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<script>
<%	if(flag==true){%>
		alert("정상적으로 처리되었습니다.");		
		parent.window.close();	
<%		}else{%>
			alert("에러발생!");
<%		}%>

</script>
</body>
</html>

