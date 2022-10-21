<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*,acar.user_mng.*"%>
<%@ page import="acar.consignment.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "22", "02");	
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	String mm_seq 		= request.getParameter("mm_seq")==null?"":request.getParameter("mm_seq");
	String reg_st 		= request.getParameter("reg_st")==null?"":request.getParameter("reg_st");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	ConsignmentBean cons_mm 		= cs_db.getConsignmentMM(mm_seq);
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function save()
	{
		var fm = document.form1;
		if(fm.cons_dt.value == '')									{	alert('Ź�����ڸ� �Է��Ͻʽÿ�');	fm.cons_dt.focus(); 	return;	}		
		if(fm.req_nm.value == '')									{	alert('�Ƿ��ڸ� �Է��Ͻʽÿ�');		fm.req_nm.focus(); 		return;	}
		if(fm.car_no1.value == '' && fm.car_no2.value == '')		{	alert('������ȣ�� �Է��Ͻʽÿ�');	fm.car_no1.focus(); 	return;	}		
		if(fm.content.value == '')									{	alert('������ �Է��Ͻʽÿ�');		fm.content.focus(); 	return;	}
		
		if(get_length(fm.content.value) > 2000){
			alert("���� 2000��, �ѱ� 1000�� ������ �Է��� �� �ֽ��ϴ�.");
			return;
		}
		
		fm.action = "cons_reg_off_iu_a.jsp";	
		fm.target='i_no';
		fm.submit();
	}
	
	function cons_reg_off_del(){
		var fm = document.form1;

		if(!confirm('�����Ͻðڽ��ϱ�?'))
			return;		
		if(!confirm('���� �����Ͻðڽ��ϱ�?'))
			return;		
				
		fm.action = "cons_reg_off_d_a.jsp";	
		fm.target='i_no';
		fm.submit();		
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


//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='mm_seq' 	value='<%=mm_seq%>'>
  <input type='hidden' name='from_page' value='<%=from_page%>'>    
  <input type='hidden' name='mode' 		value='<%=mode%>'>      
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>���¾�ü > Ź�۰��� > <span class=style5>������ȭ��û 
					<%if(mm_seq.equals("")){%>���<%}else{%>����<%}%></span></span></td>
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
            <table border="0" cellspacing="1" cellpadding="0" width=100%>         
                <tr> 
                    <td width='13%' class='title'>Ź������</td>
                    <td>&nbsp;
        			  <input type='text' name="cons_dt" value='<%=AddUtil.ChangeDate2(cons_mm.getMm_cons_dt())%>' size='11' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
        			</td>	
                </tr>					
                <tr> 
                    <td width='13%' class='title'>�Ƿ���</td>
                    <td>&nbsp;
        			  <select name='req_nm'>
                        <option value="">����</option>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(cons_mm.getMm_req_nm().equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}%>
                      </select>
					  (�Ƹ���ī ����)
        			</td>	
                </tr>					
                <tr> 
                    <td width='13%' class='title'>������ȣ</td>
                    <td>&nbsp;
        			  ����1 : <input type='text' name='car_no1' style='IME-MODE: active' size='15' class='text' value='<%=cons_mm.getMm_car_no1()%>' maxlength='20'>
					  &nbsp;
					  ����2 : <input type='text' name='car_no2' style='IME-MODE: active' size='15' class='text' value='<%=cons_mm.getMm_car_no2()%>' maxlength='20'>
					  (�ִ� 2����� �Է°���)
        			</td>	
                </tr>					
                <tr> 
                    <td width='13%' class='title'>�Ƿڳ���</td>
                    <td>&nbsp;
        			  <textarea rows='15' name='content' cols='72' maxlength='2000' style='IME-MODE: active' ><%=cons_mm.getMm_content()%></textarea>
        			</td>	
                </tr>		
            </table>
        </td>
    </tr>
	<tr>
	    <td>* Ź���Ƿڵ���� ���� ����, ��ȭ��û�� ���� �� �Ƿڿ� ���ؼ� �뷫������ �Է����ּ���.</td>
	</tr>			
	<tr>
	    <td>* �Ƿ��ڴ� �� ������ �������� Ź�۵���� �� ���Դϴ�.</td>
	</tr>	
	<%if(!reg_st.equals("���")){%>
	<tr>
	    <td align="right">
	    	 <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>
		  &nbsp;<a href="javascript:window.save();" onMouseOver="window.status=''; return true"><%if(mm_seq.equals("")){%><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle><%}else{%><img src="/acar/images/center/button_modify.gif"  border="0" align=absmiddle><%}%></a>
		  <% } %>
		  <%if(cons_mm.getReg_id().equals(user_id) || cons_mm.getMm_req_nm().equals(user_id) || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("Ź�۰�����",user_id)){%>
		  &nbsp;&nbsp;<a href="javascript:cons_reg_off_del()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_delete.gif"  aligh="absmiddle" border="0"></a>
		  <%}%>
		    <a href='javascript:window.close();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif"  aligh="absmiddle" border="0"></a>
		  
		</td>
	</tr>		
	<%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>