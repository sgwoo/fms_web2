<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.coolmsg.*,  acar.user_mng.* "%>
<jsp:useBean id="FineDocDb" 	scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
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
	
	String cms_code = request.getParameter("cms_code")==null?"":request.getParameter("cms_code");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
%>

<%
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	int count = 0;
	boolean flag = true;	
	
	flag = FineDocDb.updateFineDocCms(doc_id, cms_code);
				
	// allot ����ڵ� �ݿ�
	flag = FineDocDb.updateFineDocListAllot(doc_id, cms_code);	
	
	//�����û cms ����°� Ʋ�� ��� - �޼��� ����
	
	Vector vt = FineDocDb.getMemberCmsList(doc_id);
	int vt_size = vt.size();
	
	String cont_val  = "";
	boolean flag2 = true;
	
	String sub 	= "CMS ��� ����� Ȯ�ο�û";
	String cont   = "";
	
							
	    //����ڿ��� �޼��� ����------ ������ ���Ƽ� �α׷� ����------------------------------------------------------------------------------------							
	UsersBean sender_bean 	= umd.getUsersBean("999999");
					
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			//cont_val = cont_val + " , "   +  String.valueOf(ht.get("RENT_L_CD")) + " ";
				
				
			cont +=  "�� ����ȣ "+ String.valueOf(ht.get("RENT_L_CD"))+"��  ����� "+  String.valueOf(ht.get("CMS_START_DT"))  + "  ����� Ȯ�� ."+String.valueOf(ht.get("CMS_CODE")) + "�� ��Ͽ�� \n "   ;  	
				
	}												
					
			String url 		= "";				
								
			url 		= "/fms2/cms/master_cms_reg.jsp";		 
			
				String target_id =nm_db.getWorkAuthUser("CMS����"); 	   // "000131"; //��꼭 �����		//000113->000058->�Ǹ��(000131) -> 000129(���μ�)
			//	String target_id ="000212"; 	   // "000131"; //��꼭 �����		//000113->000058->�Ǹ��(000131) -> 000129(���μ�)
						
				//����� ���� ��ȸ
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
				System.out.println("��޽���(CMS ��� ����� Ȯ�ο�û) "+cms_code ) ;
				System.out.println(cont ) ;
				

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
		alert("���������� ó���Ǿ����ϴ�.");		
		parent.window.close();	
<%		}else{%>
			alert("�����߻�!");
<%		}%>

</script>
</body>
</html>

