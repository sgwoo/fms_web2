<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*,acar.common.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="dept_bean" class="acar.user_mng.DeptBean" scope="page"/>
<jsp:useBean id="area_bean" class="acar.user_mng.AreaBean" scope="page"/>
<jsp:useBean id="br_bean" class="acar.user_mng.BranchBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//����ں� ���� ��ȸ �� ���� ������ - 20220405 :����, �μ�, �������� ������ ���� ����.: �λ�߷ɿ��� ���� ( pl�� ����)
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String br_id = "";
	String br_nm = "";
	String user_nm = "";
	String id = "";
	String user_psd = "";
	String user_cd = "";
	String user_ssn = "";
	String user_ssn1 = "";
	String user_ssn2 = "";
	String dept_id = "";
	String dept_nm = "";
	String user_h_tel = "";
	String user_m_tel = "";
	String user_i_tel = "";
	String user_email = "";
	String user_pos = "";
	String user_job = "";
	String lic_no = "";
	String lic_dt = "";
	String enter_dt = "";
	String user_zip = "";
	String user_addr = "";
	String content = "";
	String filename = "";
	String filename2 = "";
	String user_aut2 = "";
	String user_work = "";
	String in_tel = "";
	String hot_tel = "";
	String out_dt = "";
	String taste = "";
	String special ="";
	String gundea = "";
	String area_id = "";
	String ars_group = "";
	int count = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	//����� ���� ��ȸ
	user_bean 	= umd.getUsersBean(user_id);
	br_id 		= user_bean.getBr_id();
	br_nm 		= user_bean.getBr_nm();
	user_nm 	= user_bean.getUser_nm();
	id 		= user_bean.getId();
	user_psd 	= user_bean.getUser_psd();
	user_cd 	= user_bean.getUser_cd();
	user_ssn 	= user_bean.getUser_ssn();
	user_ssn1 	= user_bean.getUser_ssn1();
	user_ssn2 	= user_bean.getUser_ssn2();
	dept_id 	= user_bean.getDept_id();
	dept_nm 	= user_bean.getDept_nm();
	user_h_tel 	= user_bean.getUser_h_tel();
	user_m_tel 	= user_bean.getUser_m_tel();
	user_i_tel 	= user_bean.getUser_i_tel();
	user_email 	= user_bean.getUser_email();
	user_pos 	= user_bean.getUser_pos();
	user_job 	= user_bean.getUser_job();
	user_aut2 	= user_bean.getUser_aut();
	lic_no 		= user_bean.getLic_no();
	lic_dt 		= user_bean.getLic_dt();
	enter_dt 	= user_bean.getEnter_dt();
	content 	= user_bean.getContent();
	filename 	= user_bean.getFilename();
	filename2 	= user_bean.getFilename2();
	user_work 	= user_bean.getUser_work();
	in_tel		= user_bean.getIn_tel();
	hot_tel		= user_bean.getHot_tel();
	out_dt		= user_bean.getOut_dt();
	taste		= user_bean.getTaste();
	special		= user_bean.getSpecial();
	gundea		= user_bean.getGundea();
	area_id		= user_bean.getArea_id();
	ars_group   = user_bean.getArs_group();
	
	
	//�μ�����Ʈ ��ȸ
	DeptBean dept_r [] = umd.getDeptAll();
	//��������Ʈ ��ȸ
	BranchBean br_r [] = umd.getBranchAll();
	//�ٹ�������Ʈ ��ȸ
	AreaBean area_r [] = umd.getAreaAll("");
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP"); //��������� ����Ʈ
	int user_size = users.size();
	
	int s=0; 
	String app_value[] = new String[2];	
	if(ars_group.length() > 0){
		StringTokenizer st = new StringTokenizer(ars_group,"/");				
		while(st.hasMoreTokens()){
			app_value[s] = st.nextToken();
			s++;
		}		
	}	
	
	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "USERS";
	String content_seq  = user_id;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();	
	
	String file1_yn = "";
	String file2_yn = "";
	
	String login_ip = request.getRemoteAddr();//�α���IP
	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//��й�ȣ ����
	function ChangePwd(){
		window.open("/fms2/menu/pass_u.jsp?user_id=<%=user_id%>&from_page=info_u.jsp", "PASS", "left=200, top=100, width=400, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//����
	function UserUp(){
		var theForm = document.form1;
		theForm.user_email.value = theForm.email_1.value+'@'+theForm.email_2.value;		
		
		if(theForm.t_zip.value=="")		{		alert("�ֹε���ּ� �����ȣ�� �Է����ϼ���!!.");		theForm.t_zip.focus();			return false;	}
		if(theForm.t_zip.value.length>5)	{	alert("�����ȣ�� 5�ڸ��� ���� �� �����ϴ�.\n\n 5�ڸ� �̻��ϰ�� �����ڿ��� �����ּ���.");			theForm.t_zip.focus();		return false;	}	
				
		if(!confirm('�����Ͻðڽ��ϱ�?')){ return; }
		theForm.cmd.value= "u";
		theForm.target="i_no";
		theForm.submit();
	}
	
	//���
	function UserDel(){
		var theForm = document.form1;
		if(!confirm('���ó�� �Ͻðڽ��ϱ�?')){ return; }
		if(!confirm('���� ���ó�� �Ͻðڽ��ϱ�?')){ return; }		
		if(!confirm('��¥ ���� ���ó�� �Ͻðڽ��ϱ�?')){ return; }				
		theForm.cmd.value= "d";
		theForm.target="i_no";
		theForm.submit();
	}
	
	//�����ø��������� �˾�
	function photo(st){
		var SUBWIN="/acar/menu/info_photo.jsp?user_id=<%=user_id%>&auth_rw=<%=auth_rw%>&file_st="+st;	
		window.open(SUBWIN, "InfoUpPhoto", "left=300, top=250, width=430, height=300, scrollbars=no");
	}
	
	function set_o_addr() //�ּ� ��üũ
	{
		var fm = document.form1;
		if(fm.c_ho.checked == true)
		{
			fm.h_zip.value = fm.t_zip.value;
			fm.h_addr.value = fm.t_addr.value;
		}
		else
		{
			fm.h_zip.value = '';
			fm.h_addr.value = '';
		}
	}
	
	function ChangeArs(){
		window.open("/fms2/menu/ars_user_search.jsp?user_id=<%=user_id%>&dept_id=<%=dept_id%>&loan_st=<%=user_bean.getLoan_st()%>&ars_group=<%=ars_group%>", "ARS_GROUP", "left=200, top=100, width=500, height=350, scrollbars=yes, status=yes, resizable=yes");
	}
//-->
</script>

<style type=text/css>
<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}

.readonly{color: #d9d9d9;} 
-->
</style>
</head>
<body  onLoad="self.focus()">
<form action="./user_null_ui.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">  
  <input type="hidden" name="filename" value="<%=filename%>">
  <input type="hidden" name="user_ssn" value="">
  <input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=880>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=/acar/images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > ����ڰ��� > <span class=style5>����ڼ���  (<%=login_ip%>) </span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
           	    <tr>
		            <td class=title>ID(�����ȣ)</td>
		            <td>&nbsp;<input type="text" name="id" value="<%=id%>" size="15" class=whitetext readonly></td>
		            <td class=title>��й�ȣ</td>
		            <td colspan='3'>&nbsp;<input type="password" name="user_psd" value="<%=user_psd%>" size="11" class=whitetext readonly>
					&nbsp;&nbsp;
					<%if(out_dt.equals("")){%>
					<input type="button" class="button" id="cng_pw" value='��й�ȣ����' onclick="javascript:ChangePwd();">
					<%}%>
					</td>
           	    </tr>	            
                <tr>			    	
					<td class=title>�Ի�����</td>
			        <td>&nbsp;<input type="text" name="enter_dt" value="<%=enter_dt%>" size="15" class=whitetext readonly></td>
			        <td class=title>�������</td>
			        <td colspan='3'>&nbsp;<%=out_dt%>			        
			        <%if(out_dt.equals("") && nm_db.getWorkAuthUser("������",ck_acar_id) && !user_id.equals("000003")){%>
			        <input type="text" name="out_dt" value="<%=out_dt%>" size="11" class=text>
			        <input type="button" class="button" id="cng_pw" value='���ó��' onclick="javascript:UserDel();">				        
				    <%}%>					
					</td>
           	    </tr>	            
                <tr>			    	
                    <td class=title width=100>����</td>			    	
                    <td width=180>&nbsp;<select name="br_id"class="readonly" onFocus="this.initialSelect = this.selectedIndex;" onChange="this.selectedIndex = this.initialSelect;">
            			  <option value="">����</option>
        <%    				for(int i=0; i<br_r.length; i++){
                				br_bean = br_r[i];%>
           				  <option value="<%= br_bean.getBr_id() %>"><%= br_bean.getBr_nm() %></option>
        <%					}%>
        				</select>
        				<script language="javascript">
        					document.form1.br_id.value = '<%=br_id%>';
        				</script>
                    </td>			    	
                    <td class=title width=100>�μ�</td>			        
                    <td colspan='3'>&nbsp;<select name="dept_id" class="readonly" onFocus="this.initialSelect = this.selectedIndex;" onChange="this.selectedIndex = this.initialSelect;">
        			      <option value="">����</option>
        <%    				for(int i=0; i<dept_r.length; i++){
                				dept_bean = dept_r[i];%>
           				  <option value="<%= dept_bean.getCode() %>"><%= dept_bean.getNm() %></option>
        <%					}%>								
        				</select>
        				<script language="javascript">
        					document.form1.dept_id.value = '<%=dept_id%>';
        				</script>
                    </td>
             
			    </tr>
			    <%if(dept_id.equals("1000") || dept_id.equals("8888")){%>
           	    <%}else{%>
				 <tr>
		            <td class=title>����</td>
		            <td>&nbsp;<input type="text" name="user_pos" value="<%=user_pos%>" size="15" class=text style='IME-MODE: active' <%if(!user_id.equals("")){%>readonly<%}%>></td>
			        <td class=title>��å</td>
			        <td>&nbsp;<input type="text" name="user_job" value="<%=user_job%>" size="15" class=text style='IME-MODE: active'></td>
			        <td class=title width=100>����</td>
			        <td width=150>&nbsp;
			            <select name="loan_st" class="readonly" onFocus="this.initialSelect = this.selectedIndex;" onChange="this.selectedIndex = this.initialSelect;">
			        		<option value="">����</option>
			        		<%if(dept_id.equals("1000") || dept_id.equals("8888")){%>
			        		<%}else{%>
			    			<option value="1" <%if(user_bean.getLoan_st().equals("1"))%>selected<%%>>�ܱ���-1��</option>
			    			<option value="2" <%if(user_bean.getLoan_st().equals("2"))%>selected<%%>>�ܱ���-2��</option>			    			
			    			<option value="" <%if(user_bean.getLoan_st().equals(""))%>selected<%%>>������</option>
			    			<%} %>
						</select>
			        </td>       			        
           	    </tr>	
           	    <%} %>	    
				<tr>
		            <td class=title>������ȣ</td>
		            <td>&nbsp;<input type="text" name="in_tel" value="<%=in_tel%>" size="15" class=text></td>
			        <td class=title>�繫��(����)</td>
			        <td colspan='3'>&nbsp;<input type="text" name="hot_tel" value="<%=hot_tel%>" size="16" class=text></td>
           	    </tr>   
           	    <%if(dept_id.equals("1000") || dept_id.equals("8888")){%>
           	    <%}else{%>
            	<tr>
			    	<td class=title>����ID</td>
			    	<td>&nbsp;<input type="text" name="mail_id" value="<%=user_bean.getMail_id()%>" size="15" class=whitetext style="ime-mode:disabled" readonly>
                    </td>
			    	<td class=title>����PW</td>
			    	<td colspan='3'>&nbsp;<%=umd.getVoaMailPswd(user_bean.getMail_id())%></td>
            	</tr>
				<tr>
		            <td class=title>���ͳ��ѽ�</td>
			    	<td colspan='5'>&nbsp;���Ź�ȣ : <input type="text" name="i_fax" value="<%=user_bean.getI_fax()%>" size="15" class=text style="ime-mode:disabled">
			    	&nbsp;&nbsp;ID : <input type="text" name="fax_id" value="<%=user_bean.getFax_id()%>" size="15" class=whitetext style="ime-mode:disabled" readonly>
			    	&nbsp;&nbsp;PW : <input type="text" name="fax_pw" value="<%=user_bean.getFax_pw()%>" size="15" class=whitetext readonly>
			    	</td>
            	</tr>
           	    <%	if(user_bean.getLoan_st().equals("1")){%>        	    
           	    <tr>
			        <td class=title>ä����Ʈ��</td>
			        <td>&nbsp;
        			    <select name="partner_id">
        			    <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(user_bean.getPartner_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                        </select>
			        </td>
			        <td class=title>ARS��Ʈ��</td>
			        <td colspan='3'>&nbsp;
			            <%for(int j=0 ; j < s ; j++){%>
			            	<%=umd.getUserNm(app_value[j])%> 
						<%}%>
						<%if(out_dt.equals("")){%>
        			    &nbsp;<input type="button" class="button" id="cng_ars" value='ARS��Ʈ�ʰ���' onclick="javascript:ChangeArs();">
        			    <%}%>
			        </td>
           	    </tr>
           	    <%	} %>	
           	    <%	if(user_bean.getLoan_st().equals("")){%>        	    
           	    <tr>
			        <td class=title>���ñٹ���Ʈ��</td>
			        <td colspan='5'>&nbsp;
			            <%for(int j=0 ; j < s ; j++){%>
			            	<%=umd.getUserNm(app_value[j])%> 
						<%}%>
						<%if(out_dt.equals("")){%>
        			    &nbsp;<input type="button" class="button" id="cng_ars" value='���ñٹ���Ʈ�ʰ���' onclick="javascript:ChangeArs();">
        			    <%}%>
			        </td>
           	    </tr>
           	    <%	} %>	           	    
           	    
           	    <%} %>				       	
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100%>      	      	    
                <tr>
        		    <td class=title width=100>�̸�</td>
        	        <td width=180>&nbsp;<input type="text" name="user_nm" value="<%=user_nm%>" size="15" class=whitetext style='IME-MODE: active' readonly></td>			    	
                    <td class=title width=100>�ֹι�ȣ</td>
	    	        <td>&nbsp;<input type="text" name="user_ssn1" value="<%=user_ssn1%>" size="6" maxlength=6 class=whitetext readonly>-<input type="password" name="user_ssn2" value="<%=user_ssn2%>" size="7" maxlength=7 class=whitetext readonly></td>	    
           	    </tr>

           	    <tr>
		            <td class=title>����ȭ</td>
		            <td>&nbsp;<input type="text" name="user_h_tel" value="<%=user_h_tel%>" size="15" class=text></td>
			        <td class=title>�޴���</td>
			        <td>&nbsp;<input type="text" name="user_m_tel" value="<%=user_m_tel%>" size="16" class=text></td>
           	    </tr>
           	    	    
					<%	String email_1 = "";
						String email_2 = "";
						if(!user_email.equals("")){
							int mail_len = user_email.indexOf("@");
							if(mail_len > 0){
								email_1 = user_email.substring(0,mail_len);
								email_2 = user_email.substring(mail_len+1);
							}
						}
					%>													
           	    <tr>
			        <td class=title>�̸���</td>
			        <td colspan=3>&nbsp;
					  <input type='text' size='15' name='email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='15' name='email_2' value='<%=email_2%>'maxlength='100' class='text' style='IME-MODE: inactive'>
					  		    <select id="email_domain" align="absmiddle" onChange="javascript:document.form1.email_2.value=this.value;">
								  <option value="" selected>�����ϼ���</option>
								  <option value="hanmail.net">hanmail.net</option>
								  <option value="naver.com">naver.com</option>
								  <option value="nate.com">nate.com</option>
								  <option value="bill36524.com">bill36524.com</option>
								  <option value="gmail.com">gmail.com</option>
								  <option value="paran.com">paran.com</option>
								  <option value="yahoo.com">yahoo.com</option>
								  <option value="korea.com">korea.com</option>
								  <option value="hotmail.com">hotmail.com</option>
								  <option value="chol.com">chol.com</option>
								  <option value="daum.net">daum.net</option>
								  <option value="hanafos.com">hanafos.com</option>
								  <option value="lycos.co.kr">lycos.co.kr</option>
								  <option value="dreamwiz.com">dreamwiz.com</option>
								  <option value="unitel.co.kr">unitel.co.kr</option>
								  <option value="freechal.com">freechal.com</option>
								  <option value="">���� �Է�</option>
							    </select>
						        <input type='hidden' name='user_email' value='<%=user_email%>'>								
								</td>
           	    </tr>

				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								// �˾����� �˻���� �׸��� Ŭ�������� ������ �ڵ带 �ۼ��ϴ� �κ�.
								// �����ȣ�� �ּ� ������ �ش� �ʵ忡 �ְ�, Ŀ���� ���ּ� �ʵ�� �̵��Ѵ�.
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.address;
								
							}
						}).open();
					}
				</script>			
				<tr>
				  <td class=title>�ֹε���ּ�</td>
				  <td colspan=3>&nbsp;
					<input type="text" class='text' name="t_zip" id="t_zip" size="7" readonly maxlength='7' value="<%=user_bean.getZip()%>">
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��">&nbsp;
					<input type="text" class='text' name="t_addr" id="t_addr" size="75" value="<%=user_bean.getAddr()%>" style='IME-MODE: active'>
				  </td>
				</tr>           	    
				<tr>
				  <td class=title>�ǰ������ּ�</td>
				  <script>
					function openDaumPostcode1() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('h_zip').value = data.zonecode;
								document.getElementById('h_addr').value = data.address;
								
							}
						}).open();
					}
				</script>	
				  <td colspan=3>&nbsp;
					<input type="text" class='text' name="h_zip" id="h_zip" size="7" maxlength='7' readonnly  value="<%=user_bean.getHome_zip()%>">
					<input type="button" onclick="openDaumPostcode1()" value="�����ȣ ã��">&nbsp;
					<input type="text" class='text' name="h_addr" id="h_addr" size="75" value="<%=user_bean.getHome_addr()%>" style='IME-MODE: active'>
                    &nbsp;
				    <input type='checkbox' name='c_ho' onClick='javascript:set_o_addr()'>��
				  </td>
				</tr>				
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100%>     		
				<%if(dept_id.equals("1000") || dept_id.equals("8888")){%>
           	    <tr>
		            <td class=title width=100%>������</td>
           	    </tr>
           	    <tr>
		            <td align="center"><textarea name="user_work" cols="70" rows="5" class="text" style='IME-MODE: active'><%=user_work%></textarea></td>		            
           	    </tr>
           	    <%}else{%>		
           	    <tr>
		            <td class=title width=390>������</td>
		            <td class=title width=390>FMS ���λ縻</td>
           	    </tr>
           	    <tr>
		            <td align="center"><textarea name="user_work" cols="51" rows="5" class="text" style='IME-MODE: active'><%=user_work%></textarea></td>		            
		            <td align="center"><textarea name="content" cols="51" rows="5" class="text" style='IME-MODE: active'><%=content%></textarea></td>
           	    </tr>
           	    <%} %>
           	    <%if(dept_id.equals("1000") || dept_id.equals("8888")){%>
           	    <%}else{%>
           	    <tr>
		            <td class=title>����  (�ܺο�-FMS������&��FMS)</td>
		            <td class=title>����  (���ο�-�����FMS)</td>
           	    </tr>
           	    <tr>
                    <td align="center">
                    
                                                <%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);
    								if(String.valueOf(ht.get("CONTENT_SEQ")).equals(content_seq+"1")){
    									file1_yn = "Y";
    									
    						%>
    							<img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" border="0" width="85" height="105">    							
    							<% if(out_dt.equals("")){%>&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a><%}%>
    						<%		}%>		
    						<%	}%>		
    						<%}
    						  if(out_dt.equals("") && file1_yn.equals("")){%>
    						<a href="javascript:photo('1');"><img src=/acar/images/pop/button_p_upload.gif border=0 align=absmiddle></a> 
    						<%}%>        			    
                    </td>
                    <td align="center">
                    
                                                <%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable ht = (Hashtable)attach_vt.elementAt(j);
    								if(String.valueOf(ht.get("CONTENT_SEQ")).equals(content_seq+"2")){
    									file2_yn = "Y";
    									
    						%>
    							<img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" border="0" width="85" height="105">    														
    							<% if(out_dt.equals("")){%>&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a><%}%>
    						<%		}%>		
    						<%	}%>		
    						<%}
    						  if(out_dt.equals("") && file2_yn.equals("")){%>
    						<a href="javascript:photo('2');"><img src=/acar/images/pop/button_p_upload.gif border=0 align=absmiddle></a> 
    						<%}%>        	
                    </td>
                </tr>				
                <%} %>
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>    
                <tr>
    			    <td align="center">
    <%				if(out_dt.equals("") && (ck_acar_id.equals(user_id) || nm_db.getWorkAuthUser("�����ڸ��",ck_acar_id))){%>			  
    		        <a href="javascript:UserUp()"><img src=/acar/images/pop/button_modify.gif border=0></a>
    		        &nbsp;&nbsp;&nbsp;
    <%				}%>    
     		        <a href="javascript:self.close();window.close();"><img src=/acar/images/pop/button_close.gif border=0></a>
    			    </td>
			    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>