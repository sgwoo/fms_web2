<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*,  acar.receive.*"%>
<jsp:useBean id="rc_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
		//�߽�����
	ClsBandBean cls_band = rc_db.getClsBandInfo(rent_mng_id, rent_l_cd);	

%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchopenBrWindow();
	}
	
			
	//���
	function doc_reg(){
		var fm = document.form1;
		
		if(fm.band_st.value == '')		{ alert('�Աݱ����� �����Ͻʽÿ�.'); 	return; }
		if(fm.band_ip_dt.value == '')	{ alert('�Ա����ڸ� �Է��Ͻʽÿ�.'); 	return; }		
		 if( toInt(parseDigit(fm.draw_amt.value)) < 1 ) { 	 alert('ȸ���ݾ��� �Է��Ͻʽÿ�'); 		fm.band_amt.focus(); 		return;	}		
		 if( toInt(parseDigit(fm.ip_amt.value)) < 1 ) { 	 alert('�Աݱݾ��� �Է��Ͻʽÿ�'); 		fm.ip_amt.focus(); 		return;	}		
		 if( toInt(parseDigit(fm.rate_amt.value)) < 1 ) { 	 alert('�����Ḧ �Է��Ͻʽÿ�'); 		fm.rate_amt.focus(); 		return;	}		
						
		if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}		
		fm.action = "rece_c7_reg_a.jsp";
		fm.target = "i_no";
		fm.submit()
		
	}
		
	//�ݾ� ����
	function set_rate_amt(){
		var fm = document.form1;	
	
		if ( toInt(parseDigit(fm.draw_amt.value)) ==  toInt(parseDigit(fm.ip_amt.value))   ) {	
			fm.rate_amt.value 	= parseDecimal(        toInt(parseDigit(fm.draw_amt.value)) * toInt(fm.re_rate.value) / 100    );		 		
		} else {
				
		}
		
	
				
	}				
	
			
	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post' >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=ck_acar_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
<input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ä�ǰ��� > ä���߽ɰ��� > <span class=style5>ä��ȸ�� ���</span></span></td>
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
      <td class="line"> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width=14%>�Աݱ���</td>
              <td>&nbsp; 
			  <select name="band_st">
			    <option value="">---����---</option>
		                <option value="1">�κ��Ա�</option>             
		                <option value="2">����</option>  
              </select> </td>                    
          </tr>
	 
	 <tr> 
            <td class='title'>�Ա���</td>
            <td>&nbsp;&nbsp;<input type="text" name="band_ip_dt" value="<%=AddUtil.getDate()%>" size="11" class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 
          </tr>
          <tr> 
            <td class='title'>ȸ���ݾ�</td>
            <td>&nbsp;&nbsp;<input type="text" name="draw_amt" value="" size="15" class=num onBlur='javascript:this.value=parseDecimal(this.value); '></td>
          </tr>
           <tr> 
            <td class='title'>���Աݾ�</td>
            <td>&nbsp;&nbsp;<input type="text" name="ip_amt" value="" size="15" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_rate_amt();'></td>
          </tr>

	 <tr> 
            <td class='title'>������</td>
            <td>&nbsp;&nbsp;<input type="text" name="rate_amt" value="" size="15" class=num onBlur='javascript:this.value=parseDecimal(this.value); '>
            &nbsp;&nbsp;*��������: ȸ���ݾ��� <input type="text" name="re_rate" value="<%=cls_band.getRe_rate()%>" size="3" class=num>%</td>	             
 
          </tr>  
          <tr> 
            <td class='title'>������������</td>
            <td>&nbsp;&nbsp;<input type="text" name="rate_jp_dt" value="<%=AddUtil.getDate()%>" size="11" class='text' onBlur='javascript: this.value = ChangeDate(this.value); '></td> 
          </tr>

        </table>
      </td>
    </tr>
    <tr>
        <td></td>
    </tr>
		
    <tr>
      <td align="right">
	
	  <a href='javascript:doc_reg()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
	
	  </td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
