<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.ars_card.*, acar.res_search.* "%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ar_db" scope="page" class="acar.ars_card.ArsCardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	
	String ars_code 	= request.getParameter("ars_code")==null?"":request.getParameter("ars_code");
	
	
	ArsCardBean ars = ar_db.getArsCard(ars_code);
	
	
	
		//�������� �������� �ִ��� Ȯ���Ѵ�.
	Hashtable ht_ax = rs_db.getAxHubCase(ars_code, "", ars.getGood_mny());
	
	
	String am_ax_code = String.valueOf(ht_ax.get("AM_AX_CODE"))==null?"":String.valueOf(ht_ax.get("AM_AX_CODE"));
	
	
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
	//�����ϱ�
	function save(){
		var fm = document.form1;	
		
		if(fm.m_tel.value == ''){ alert('�޴�����ȣ�� �Է��Ͻʽÿ�'); fm.m_tel.focus(); return; }							
		if(fm.m_tel.value.length  < 10)		{ alert('�޴�����ȣ�� Ȯ���Ͻʽÿ�.'); fm.m_tel.focus(); return; }	
		
		if(!confirm('�߼��Ͻðڽ��ϱ�?')){		return;	}
		fm.action = 'ax_hub_order_send_a.jsp';
		fm.target = 'i_no';
		//fm.target = '_self';
		fm.submit();			
	}
	
	function Resend(){
		var fm = document.form1;	
		if(!confirm('����� �Ͻðڽ��ϱ�?')){	return;	}			
		fm.action = 'ax_hub_order_resend_a.jsp';
		fm.target = 'i_no';
		//fm.target = '_self';
		fm.submit();		
	}
	
	function set_amt(){
		var fm = document.form1;
		//fm.am_good_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.am_good_amt.value)) - toInt(parseDigit(fm.am_good_m_amt.value)) );
	}	
		
</script>
</head>
<body>

<form action="" name="form1" method="post" >
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='ars_code' 	value='<%=ars_code%>'>
  <input type='hidden' name='am_ax_code' value='<%=am_ax_code%>'>
 
       
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ȸ����� > ���ݰ��� > <span class=style5>ī����� ������ȣ �߼�</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��������</span></td>
    </tr>              
    <tr><td class=line2></td></tr>  
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=15%>����ڸ�</td>
                    <td>&nbsp;
                        <%=ars.getBuyr_name()%></td>
                </tr>								
                <tr> 
                    <td class=title width=10%>������ȣ</td>
                    <td>&nbsp;
                        <%=ars.getGood_name()%></td>
                </tr>								
                <tr> 
                    <td class=title width=10%>����</td>
                    <td>&nbsp;
                        <%=ars.getGood_cont()%>                      
                    </td>
                </tr>			            
        
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <%if(am_ax_code.equals("") || am_ax_code.equals("null")){%>
    <tr><td class=line2></td></tr> 
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=15%>�߼۹��</td>
                   <td>
                      &nbsp;�޴�������        		    
                    </td>
                </tr>
                <tr> 
                    <td class=title>�޴�����ȣ</td>
                   <td>
                      &nbsp;<input type="text" name="m_tel" value="<%=ars.getBuyr_tel2()%>" size="15" class=text>
                      (������ȣ ���� ��ȣ)
                      <input type='hidden' name='email' value='<%=ars.getBuyr_mail()%>'>
                    </td>
                </tr>  
                <tr> 
                    <td class=title width=10%>����</td>
                    <td>
                        &nbsp;<select name="am_good_st">			    
			    <option value="���뿩">���뿩</option>
	          	    <!--<option value="����Ʈ">����Ʈ</option>-->
			</select>                                                                                            
                    </td>
                </tr>		                              
                <tr> 
                    <td class=title>ī������ݾ�</td>
                    <td> 
                      &nbsp;<input type="text" name="am_good_amt" value="<%=AddUtil.parseDecimal(ars.getGood_mny())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>��
                    </td>
                </tr>      
                <tr> 
                    <td class=title>����</td>
                    <td> 
                      &nbsp;���ް� : <input type="text" name="am_good_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>��
                      &nbsp;�ΰ��� : <input type="text" name="am_good_v_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>��                      
                    </td>
                </tr>                              
                <tr> 
                    <td class=title>�����</td>
                    <td> 
                      &nbsp;<input type="text" name="am_good_m_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt();'>��
                      (ī�������(3.7%) �� �����)
                    </td>
                </tr>                              
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>  		
    <tr>
	<td align="right">
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>		  	  	  
		<a href='javascript:save();'><img src="/acar/images/center/button_conf.gif" border="0" align=absmiddle></a>
	    <%}%>			
	    &nbsp;<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>				
	</td>
    </tr>    
    <%}else{%>
    <tr><td class=line2></td></tr> 
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=15%>������ȣ</td>
                   <td>
                      &nbsp;<%=String.valueOf(ht_ax.get("AM_AX_CODE"))%>
                      <input type='hidden' name='am_ax_code' 	value='<%=ht_ax.get("AM_AX_CODE")%>'>     
                    </td>
                </tr>
                <tr> 
                    <td class=title>�����ݾ�</td>
                    <td> 
                      &nbsp;<b><%=AddUtil.parseDecimal(String.valueOf(ht_ax.get("AM_GOOD_AMT")))%>��</b>
                      <input type='hidden' name='am_good_amt' 	value='<%=ht_ax.get("AM_GOOD_AMT")%>'>     
                    </td>
                </tr>
                <tr> 
                    <td class=title>�޴�����ȣ</td>
                   <td>
                      &nbsp;<%=String.valueOf(ht_ax.get("BUYR_TEL2"))%>
                    </td>
                </tr>                              
            </table>
        </td>
    </tr>     
    <tr>
        <td class=h></td>
    </tr>  
    <%		if(String.valueOf(ht_ax.get("ORDR_IDXX")).equals("")){%>	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� ��߼�</span></td>
    </tr>         
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
               <tr> 
                    <td class=title width=15%>�޴�����ȣ</td>
                   <td>
                      &nbsp;<input type="text" name="m_tel" value="<%=String.valueOf(ht_ax.get("BUYR_TEL2"))%>" size="30" class=text>  
                      (������ȣ ���� ��ȣ)                    
                    </td>
                </tr>                 
            </table>
        </td>
    </tr>   
    <tr>
        <td class=h></td>
    </tr>      
    <tr>
	<td align="right">
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>		  	  	  
		<a href='javascript:Resend();'><img src="/acar/images/center/button_conf.gif" border="0" align=absmiddle></a>
	    <%}%>			
	    &nbsp;<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>				
	</td>
    </tr>              
    <%		}else{%>    
    <tr>
        <td class=h></td>
    </tr>      
    <tr>
	<td align="right">
	    &nbsp;<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>				
	</td>
    </tr>          		
    <%		}%>
    <%}%>
</table>
</form>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
	var fee = 0;
	<%if(am_ax_code.equals("") || am_ax_code.equals("null")){%>		
		//fee = (toInt(parseDigit(fm.am_good_amt.value)) / 1.1);
		//fm.am_good_s_amt.value 	= parseDecimal(fee);
		//fm.am_good_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.am_good_amt.value))-fee);
		
		fm.am_good_s_amt.value 	= 0;
		fm.am_good_v_amt.value 	= 0;
		fm.am_good_m_amt.value 	= fm.am_good_amt.value;
	<%}%>
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
