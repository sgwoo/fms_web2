<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*,acar.user_mng.*"%>
<%@ page import="acar.util.*,acar.client.*"%>
<%@ page import="acar.cooperation.*"%>
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_year 	= request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon 	= request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup ��û�� ������
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");  // ��࿡�� �Ѿ���� ���  
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");  // ��࿡�� �Ѿ���� ���  
	
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");  //������湮���� -> gubun:park
	String idx 	= request.getParameter("idx")  ==null?"1":request.getParameter("idx");
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	if(user_id.equals(""))	user_id = ck_acar_id;
	String seq = "";
	seq = cp_db.getCooperationSeqNext();
	
	Vector users = c_db.getUserList("", "", "EMP"); //��ü���� ����Ʈ
	int user_size = users.size();
	
	Vector users2 = c_db.getUserList("0005", "", "");
	int user_size2 = users2.size();	
	
	//������
	ClientBean client = al_db.getNewClient(client_id);	
	String stitle =  rent_l_cd + " "+ client.getFirm_nm();
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language="JavaScript">
<!--
	function save()
	{
		var fm = document.form1;
		
		if(fm.title1.value == '')		{	alert('�׸��� �����ϼ���');	return;	}
		if(fm.title.value == '')		{	alert('������ �Է��Ͻʽÿ�');	return;	}
		if(fm.content.value == '')		{	alert('������ �Է��Ͻʽÿ�');	return;	}
						
		if (fm.from_page.value == "/fms2/cooperation/cooperation_it_sc.jsp" ) {
				
		} else if (fm.from_page.value == "/fms2/lc_rent/lc_s_frame.jsp" ) {
			if(fm.title1.value == '[����������ɽ�û��û]' )  		fm.sub_id.value = '<%=nm_db.getWorkAuthUser("�����������")%>';
		  
		} else {
			if(fm.req_st[1].checked == true){
				
				if(fm.email_1.value != '' && fm.email_2.value != ''){
					fm.agnt_email.value = fm.email_1.value+'@'+fm.email_2.value;
				}
				
				if(fm.agnt_m_tel.value == '' && fm.agnt_email.value == ''){
					alert('����û�� ��쿡�� �Ϸ�޽����� ���� �̵���ȭ��ȣ Ȥ�� �̸����ּҰ� �־�� �մϴ�.'); return;
				}
				if(fm.title1.value == '[���ݰ�꼭]' && fm.sub_id.value == '')  		fm.sub_id.value = '<%=nm_db.getWorkAuthUser("���ݰ�꼭�����")%>';
				if(fm.title1.value == '[����]' && fm.sub_id.value == '')  			fm.sub_id.value = '<%=nm_db.getWorkAuthUser("����������")%>';
				if(fm.title1.value == '[����ڵ��������]' && fm.sub_id.value == '')  		fm.sub_id.value = '<%=nm_db.getWorkAuthUser("���ݰ�꼭�����")%>';
				if(fm.title1.value == '[���·�]' && fm.sub_id.value == '')  			fm.sub_id.value = '<%=nm_db.getWorkAuthUser("���·�����")%>';
				if(fm.title1.value == '[ī���Ա�ó����û]' && fm.sub_id.value == '')  		fm.sub_id.value = '<%=nm_db.getWorkAuthUser("�Աݴ��")%>';
			}
		}
		
		if( fm.out_id.value == ''  && fm.sub_id.value == '' )		{	alert('������ �Ǵ� ��������ڸ� �����ϼ���');	return;	}
		
		if(get_length(fm.content.value) > 4000){
			alert("������ ����4000��/�ѱ�2000�� ������ �Է��� �� �ֽ��ϴ�.");
			return;
		}
		if(get_length(fm.title.value) > 200){
			alert("������ ����200��/�ѱ�100�� ������ �Է��� �� �ֽ��ϴ�.");
			return;
		}		
		
		if(confirm('��� �Ͻðڽ��ϱ�?')){			
			file_save();
			fm.action = "cooperation_a.jsp";
			fm.target = 'i_no';
			fm.submit();
		}
	}
	
	function get_length(f) {
		var max_len = f.length;
		var len = 0;
		for(k=0;k<max_len;k++) {
			t = f.charAt(k);
			if (escape(t).length > 4)
				len += 2;
			else
				len++;
		}
		return len;
	}	
	
	//�� ��ȸ
	function search_client()
	{
		window.open("/fms2/client/client_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/cooperation/cooperation_i.jsp", "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//�� ����
	function view_client()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���õ� ���� �����ϴ�."); return;}	
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	function search_mgr(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("���� ���� �����Ͻʽÿ�."); return;}	
		window.open("/fms2/lc_rent/search_mgr.jsp?idx="+idx+"&client_id="+fm.client_id.value+"&from_page=/fms2/cooperation/cooperation_i.jsp", "MGR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");
	}
		
	//��û�ڱ���
	function cust_display(){
		var fm = document.form1;
		if(fm.req_st[0].checked == true){ 				//����
			tr_cust1.style.display	= 'none';
			tr_cust2.style.display	= 'none';
		}else{											//��
			tr_cust1.style.display	= '';
			tr_cust2.style.display	= '';
		}
	}

	function file_save(){
		var fm2 = document.form2;	
				
		if(!confirm('���ϵ���Ͻðڽ��ϱ�?')){
			return;
		}
		
		fm2.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.COOPERATION%>";
		fm2.submit();
	}	
//-->
</script>
</head>

<body>
<form action='' name="form2" method='post' enctype="multipart/form-data">
	<input type='hidden' name="idx"	value="<%=idx%>">
	<input type='hidden' name="seq"	value="<%=seq%>">
</form>
<form action='' name="form1" method='post'>
    <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
    <input type='hidden' name='user_id' 	value='<%=user_id%>'>
    <input type='hidden' name='br_id' 	value='<%=br_id%>'>
    <input type='hidden' name='s_year' 	value='<%=s_year%>'>
    <input type='hidden' name='s_mon' 	value='<%=s_mon%>'>  
    <input type='hidden' name='s_kd' 		value='<%=s_kd%>'>
    <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>  
    <input type='hidden' name='gubun1'	value='<%=gubun1%>'>    
    <input type='hidden' name='gubun2'	value='<%=gubun2%>'>    
    <input type='hidden' name='gubun3'	value='<%=gubun3%>'>    
    <input type='hidden' name='gubun4'	value='<%=gubun4%>'>          
    <input type='hidden' name='sh_height' value='<%=sh_height%>'>   
    <input type='hidden' name='from_page' value='<%=from_page%>'>  
    <input type='hidden' name="seq"	value="<%=seq%>">   
	  
    <input type='hidden' name="file_cnt" 	value="2">   
<table border=0 cellspacing=0 cellpadding=0 width=650>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���ڹ��� > �������� > <span class=style5>�����������</span></span></td>
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
    	<td class='line'>
    	    <table border=0 cellspacing=1 cellpadding=0 width=100%>
    		<%if(from_page.equals("/fms2/cooperation/cooperation_p_sc.jsp")) { %>
    		    <input type='hidden' name="req_st" value="3" > 
    		<% } else { %> 
		<tr>
		    <td class='title' width=15%>��û�ڱ���</td>
		    <td>&nbsp;
			<%if(from_page.equals("/fms2/cooperation/cooperation_it_sc.jsp")){%>
			<input type='radio' name="req_st" value='5' onClick="javascript:cust_display()" checked >
				�ӿ� �� ����
			<%}else if (from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")){%> 
			<input type='radio' name="req_st" value='1'  checked >
				����
			<%}else { %>
			<input type='radio' name="req_st" value='1' onClick="javascript:cust_display()" <%if(!from_page.equals("/fms2/cooperation/cooperation_c_sc.jsp"))%>checked<%%>>
        		����
        		<input type='radio' name="req_st" value='2' onClick="javascript:cust_display()" <%if(from_page.equals("/fms2/cooperation/cooperation_c_sc.jsp"))%>checked<%%>>
        		��        				        				
			<%}%>
		    </td>
		</tr>
		<% } %>	
		<tr>
		    <td class='title' width=15%>�����</td>
		    <td>&nbsp;
		        <%=c_db.getNameById(user_id, "USER")%></td>
		</tr>
		<tr>
		    <td class='title'>����</td>
		    <td>&nbsp;
		        <select name='title1'>
                    	    <option value="">����</option>
			    <%if(from_page.equals("/fms2/cooperation/cooperation_c_sc.jsp")){ //����������%>						                    	
                    	    <option value="[���ݰ�꼭]">[���ݰ�꼭]</option>                    
                    	    <option value="[����]">[����]</option>
                    	    <option value="[����ڵ��������]">[����ڵ��������]</option>
                    	    <option value="[���·�]">[���·�]</option>
			    <%}else if(from_page.equals("/fms2/cooperation/cooperation_p_sc.jsp")){//������湮����%>		
			    <option value="[������湮����]">[������湮����]</option>
				<%}else if(from_page.equals("/fms2/cooperation/cooperation_it_sc.jsp")){//������湮����%>		
			    <option value="[IT�����������߾���]" selected>[IT�����������߾���]</option>
			   	<%}else if(from_page.equals("/fms2/lc_rent/lc_s_frame.jsp")){//������湮����%>		
			     <option value="[����������ɽ�û��û]">[����������ɽ�û��û]</option>	
			     <option value="[��������߼ۿ�û]">[��������߼ۿ�û]</option>    		
			     
			    <%}else{//��������%>
                    	    <option value="[ī���Ա�ó����û]">[ī���Ա�ó����û]</option>
                    	    <option value="[�ڵ�����Ͽ�û]">[�ڵ�����Ͽ�û]</option>
                    	    <option value="[��༭�ۼ���û]">[��༭�ۼ���û]</option>
                    	    <option value="[���������û]">[���������û]</option>
                    	    <option value="[���庯���û]">[���庯���û]</option>
                    	    <option value="[�����ú����û]">[�����ú����û]</option>
                    	    <option value="[�ʺ���û��û]">[�ʺ���û��û]</option>
                    	    <option value="[�����⼭��]">[�����⼭��]</option>
                    	    <option value="[�ſ���ȸ��û]">[�ſ���ȸ��û]</option>	
                    	    <option value="[���·�ó����û]">[���·�ó����û]</option>	
                    	   			
			    <%}%>
                    	    <option value="[��Ÿ]">[��Ÿ]</option>                                         	
                  	</select><br>
			&nbsp;
			<input type='text' name='title' value='<%=stitle%>' style='IME-MODE: active' size='80' class='text' maxlength='125'>
		    </td>
		</tr>
		<tr>
		    <td class='title'><br/><br/>����<br/><br/></td>
		    <td>&nbsp;
		        <textarea rows='15' name='content' cols='80' maxlength='2000' style='IME-MODE: active' ></textarea></td>
		</tr>
		<tr>
		    <td class='title'>÷������</td>
		    <td>&nbsp;
			
				<input type='file' name="file" size='40' class='text'>
				<input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=seq%><%=idx%>' />
				<input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.COOPERATION%>' />
			
			</td>
		</tr>
		<tr>
		    <td class='title'>�����μ�</td>
		    <td>&nbsp;
		        <select name='out_id'>
				<%if(from_page.equals("/fms2/cooperation/cooperation_it_sc.jsp")){%>	
				<option value="000237">IT������������ </option>
				<%}else{%>
			    <option value="">������ ���� </option>
			    <option value="000004">�ѹ����� </option>
			    <option value="000005">�������� </option>
			    <option value="000026">���������� </option>
				<option value="000237">IT������������ </option>
			    <option value="000053">������ </option>
			    <option value="000052">�ڿ��� </option>
			    <option value="000054">����Ź </option>
			    <option value="000219">���� </option>
				<%}%>
			</select>
			    (��������ڸ� �� ��)
		    </td>
		</tr>				
		<tr>
		    <td class='title'>���������</td>
		    <td>&nbsp;
		        <select name='sub_id'>
				<option value="">����� ����</option>
				<%if(from_page.equals("/fms2/cooperation/cooperation_it_sc.jsp")){%>
				<%	if(user_size2 > 0){
						for (int i = 0 ; i < user_size2 ; i++){
						Hashtable user = (Hashtable)users2.elementAt(i);	%>
			    <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
			    <%	}}%>					
				<%}else{%>
			    <%	if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
						Hashtable user = (Hashtable)users.elementAt(i);	%>
			    <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
			    <%	}}%>
				<%}%>
			</select>
		    </td>
		</tr>								
	    </table>
	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 		
    <tr id=tr_cust1 <%if(from_page.equals("/fms2/cooperation/cooperation_c_sc.jsp")){%>style="display:''"<%}else{%>style='display:none'<%}%>>
        <td class=line2></td>
    </tr>
    <tr id=tr_cust2 <%if(from_page.equals("/fms2/cooperation/cooperation_c_sc.jsp")){%>style="display:''"<%}else{%>style='display:none'<%}%>>
    	<td class='line'>
    	    <table border=0 cellspacing=1 cellpadding=0 width=100%>
		<tr>
		    <td class='title' width=15%>��</td>
		    <td>&nbsp;
		        <input type='text' name="firm_nm" value='' size='50' class='text' readonly>
        	        <span class="b"><a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        		<span class="b"><a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>		
			<input type='hidden' name='client_id' value=''>
		    </td>
		</tr>
		<tr>
		    <td class='title'>�����</td>
		    <td>&nbsp;
		        <input type='text' name='agnt_nm'    size='20' class='text' style='IME-MODE: active'>
			<span class="b"><a href='javascript:search_mgr(0)' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
			(���� �Է� ����)
		    </td>
		</tr>
		<tr>
		    <td class='title'>�̵���ȭ</td>
		    <td>&nbsp;
		        <input type='text' name='agnt_m_tel'    size='20' class='text' style='IME-MODE: active'></td>
		</tr>
		<tr>
		    <td class='title'>�̸���</td>
		    <td>&nbsp;
		        <input type='text' size='15' name='email_1' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='20' name='email_2' maxlength='100' class='text' style='IME-MODE: inactive'>
			<select id="email_domain" onChange="javascript:document.form1.email_2.value=this.value;" align="absmiddle">
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
                        <option value="empal.com">empal.com</option>
						<option value="">���� �Է�</option>
			</select>
			<input type='hidden' name='agnt_email' value=''>
			<!--<input type='text' name='agnt_email'    size='50' class='text' style='IME-MODE: active'>-->
		    </td>
		</tr>
	    </table>
	</td>
    </tr>	
    <tr>
	<td class=h></td>
    </tr>
    <tr>
	<td colspan="2">&nbsp;�� ��������ڸ� ��Ȯ�� �˸� ����ڼ���, �׷��� ������ �����μ��� �����ڸ� �����ϼ���.</td>
    </tr>
    <tr>
	<td colspan="2">&nbsp;�� ��û�ڱ����� ���϶��� �Ϸ�ó���� ������ �� ����ڿ��� �۾��Ϸ�ȳ������� �߼۵˴ϴ�.</td>
    </tr>	
    <tr>
	<td colspan="2">&nbsp;�� ������湮��û�� ��� ���õ� ������������ڿ��� SMS�� �����ϴ�.</td>
    </tr>	
    <tr>
    	<td align='right'>
    	    <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
    	    <!--&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>-->
    	</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>