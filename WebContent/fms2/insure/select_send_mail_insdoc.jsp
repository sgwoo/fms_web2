<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.im_email.*, acar.client.*, acar.user_mng.*, acar.insur.*" %>
<jsp:useBean id="al_db" class="acar.client.AddClientDatabase" scope="page"/>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>

<% 
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
	
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 			= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String mode 			= request.getParameter("mode")		==null?"":request.getParameter("mode");
	String checkScdFee 	= request.getParameter("checkScdFee")==null?"":request.getParameter("checkScdFee");
	
	String replyEmail	= "";
	String mail_addr	= "";
	
	String vid[] = request.getParameterValues("ch_cd");
	
	if(mode.equals("one")){
		replyEmail 			= request.getParameter("replyto")			==null?"":request.getParameter("replyto");
		mail_addr 			= request.getParameter("mail_addr")		==null?"":request.getParameter("mail_addr");
	}
	
	String client_id = "";	
	boolean flag = true;	
	boolean flag2 = true;	
	
	String file_seq = "";	
	
	//����� ���� ��ȸ
	user_bean 	= umd.getUsersBean(user_id);
	
	String user_email = user_bean.getUser_email();
	if(user_id.equals("000130") || user_id.equals("000048")){//000277
		user_email = "34000233@amazoncar.co.kr";
	}
	if(mode.equals("one")){
		if(!replyEmail.equals("")){
			user_email = replyEmail;
		}
	}
	
	String replyto = "\"�Ƹ���ī "+user_bean.getUser_nm()+"\"<"+user_email +">";
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	Vector total_vt =  new Vector();	
	String ch_val[] = new String[3];
	
	Hashtable ht = new Hashtable();
	Hashtable ht2 = new Hashtable();
	
	List<String[]> list = new ArrayList<String[]>();
	
	//List<String> temp = new ArrayList<String>();	
	
	for (int i = 0; i < vid.length; i++) {
		ch_val = vid[i].split("/");
		ht = ic_db.getInsComFilereqSelect(ch_val[0]);
		
		/* System.out.println("//////////////////////////////////////////////////////////////");
		System.out.println(String.valueOf(ht.get("RENT_MNG_ID")));
		System.out.println(String.valueOf(ht.get("RENT_L_CD")));
		System.out.println("//////////////////////////////////////////////////////////////"); */		
		
		ht2 = ic_db.getContInfo(String.valueOf(ht.get("RENT_MNG_ID")), String.valueOf(ht.get("RENT_L_CD")));

		ClientBean client = al_db.getNewClient(String.valueOf(ht2.get("CLIENT_ID")));
		
		String temp[] = new String[10];
 		temp[0] = client.getClient_id();
 		temp[1] = client.getFirm_nm();
		temp[2] = client.getCon_agnt_email();
		if (mode.equals("one")) {
			if (!mail_addr.equals("")) {
				temp[2] = mail_addr;
			}
		}
		temp[3] = user_email;
		temp[4] = ch_val[0]; //file_seq 
		temp[5] = String.valueOf(ht.get("RENT_MNG_ID"));
		temp[6] = String.valueOf(ht.get("RENT_L_CD"));
		
		list.add(temp);
	}
	
	Collections.sort(list,new Comparator<String[]>() {
		public int compare(String[] strings, String[] otherStrings) {
	    	return strings[1].compareTo(otherStrings[1]);
	    }
	}); 	

    String compare_id = "";
        
    client_id="";
    user_email = "";
    
    String firm_nm = "";
    String con_agnt_email = "";
    String[] seqArray = new String[20];
    String rent_mng_id = "";
    String rent_l_cd = "";
    
    int count=0;
    
	for (int i = 0; i < list.size(); i++) {
		
		client_id = list.get(i)[0];
		firm_nm = list.get(i)[1];
		con_agnt_email = list.get(i)[2];
		user_email = list.get(i)[3];
		seqArray[count] = list.get(i)[4];
		rent_mng_id = list.get(i)[5];
		rent_l_cd = list.get(i)[6];
		
		System.out.println(rent_mng_id);
		System.out.println(rent_l_cd);
		
		%>
			���� : <%=firm_nm %>
			<%=list.get(i)[4] %>
		<%
		if(i < list.size()-1) compare_id = list.get(i+1)[0]; 
		%>
			�� <%=client_id %> VS  <%=compare_id %>
		<%
		
		// ���� ��ȣ�϶� ���� �Ѱ��� ÷������ ������ ���� ������
		if (!client_id.equals(compare_id) ||  i == list.size()-1) {
			for (int j = 0; j < count+1; j++) {
				String temp_seq ="";
				if (j > 0 && j < count+1 ) temp_seq = "&";
				temp_seq += "file_seq="+seqArray[j];
				
				file_seq +=  temp_seq;
			}
		 	if (client_id.length() == 6  && con_agnt_email.length() > 8 && con_agnt_email.indexOf(".") > 0 && con_agnt_email.indexOf("@") > 0 ) {
			%>
				���� : <%=firm_nm %>
				<%=file_seq %>
			<%
	
				//�ߺ�üũ
				//�̹̺����� ������ �Ⱥ���������
				int overchk = ImEmailDb.getFmsInfoMailNotSendChkList(reg_code, "[�Ƹ���ī] "+firm_nm+" �� ������ ���� �ڵ��� ���� ���� ���� �Դϴ�.", "SSV:"+user_email);
				if (overchk == 0) {
					DmailBean d_bean = new DmailBean();
					d_bean.setSubject			("[�Ƹ���ī] "+firm_nm+" �� �ڵ��� ���� ���� ���� �Դϴ�.");
					d_bean.setSql				("SSV:"+con_agnt_email.trim());
					d_bean.setReject_slist_idx	(0);
					d_bean.setBlock_group_idx	(0);
					d_bean.setMailfrom			("\"�Ƹ���ī\"<"+user_email.trim()+">");
					d_bean.setMailto			("\""+firm_nm+"\"<"+con_agnt_email.trim()+">");
					d_bean.setReplyto			("\"�Ƹ���ī\"<no-reply@amazoncar.co.kr>");
					d_bean.setErrosto			("\"�Ƹ���ī\"<return@amazoncar.co.kr>");
					d_bean.setHtml				(1);
					d_bean.setEncoding			(0);
					d_bean.setCharset			("euc-kr");
					d_bean.setDuration_set		(1);
					d_bean.setClick_set			(0);
					d_bean.setSite_set			(0);
					d_bean.setAtc_set			(0);
					d_bean.setGubun				(reg_code);
					d_bean.setRname				("mail");
					d_bean.setMtype       		(0);
					d_bean.setU_idx       		(1);//admin����
					d_bean.setG_idx				(1);//admin����
					d_bean.setMsgflag     		(0);
					d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/ins/ins_file_docs.jsp?"+file_seq);
					d_bean.setEncoding			(0); //����÷��
					d_bean.setAtc_set			(0);
					
					String reg_code2  = Long.toString(System.currentTimeMillis());
					d_bean.setGubun2		(reg_code2);
			
					flag = ImEmailDb.insertDEmail(d_bean, "4", "", "+7");
					
					if (checkScdFee.equals("Y")) {
						
						DmailBean d_bean2 = new DmailBean();
						
						d_bean2.setSubject(firm_nm+"��, (��)�Ƹ���ī ���뿩 ������ �ȳ����Դϴ�.");
						
						d_bean2.setSql					("SSV:"+con_agnt_email); //������ ���� �������°�
						d_bean2.setReject_slist_idx	(0);
						d_bean2.setBlock_group_idx	(0);
						d_bean2.setMailfrom			("\"�Ƹ���ī\"<tax200@amazoncar.co.kr>");
						d_bean2.setMailto				("\""+firm_nm+"\"<"+con_agnt_email+">"); //�޴��� ǥ��κ�
						d_bean2.setReplyto				("\"�Ƹ���ī\"<tax200@amazoncar.co.kr>");
						d_bean2.setErrosto				("\"�Ƹ���ī\"<tax200@amazoncar.co.kr>");
						d_bean2.setHtml					(1);
						d_bean2.setEncoding			(0);
						d_bean2.setCharset				("euc-kr");
						d_bean2.setDuration_set		(1);
						d_bean2.setClick_set			(0);
						d_bean2.setSite_set			(0);
						d_bean2.setAtc_set				(0);
						
						d_bean2.setGubun				(rent_l_cd + "scd_info");
						
						d_bean2.setRname				("mail");
						d_bean2.setMtype       		(0);
						d_bean2.setU_idx       			(1);//admin����
						d_bean2.setG_idx				(1);//admin����
						d_bean2.setMsgflag     		(0);
						d_bean2.setContent				("http://fms1.amazoncar.co.kr/mailing/rent/scd_info.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&rent_st=");
						
						flag2 = ImEmailDb.insertDEmail(d_bean2, "4", "", "+7");
					}
					
				}									
			}  
			
			//compare_id = client_id;
			count=0;
			file_seq ="";
		}else{
			count++;			
		} 	
	} 
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<script language="JavaScript">
<!--
<%if(flag){%>
	alert("������ ���������� �߼� �Ǿ����ϴ�.");
	parent.window.close();
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
	parent.window.close();				
<%}%>
//-->

	var file_seq = 'file_seq=8468789&file_seq=8468789&file_seq=8468789';
	function preview(){
		var popUrl = "/mailing/ins/ins_file_docs.jsp?"+file_seq;	//�˾�â�� ��µ� ������ URL
		var popOption = "width=1200, height=1200, resizable=no, scrollbars=no, status=no;";    //�˾�â �ɼ�(optoin)
			window.open(popUrl,"",popOption);

	}
	
</script>


<!-- <input type="button" class="button" id="regbtn" value="�̸�����" onclick="preview()" style="width:60px"/>  -->
</body>
</html>



