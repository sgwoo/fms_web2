<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//등록
	function TaxRateReg(){
		var fm = document.form1;
		fm.cmd.value = "i";		
		if(fm.reg_dt.value!=""){	alert("수정만이 가능합니다.");	return;	}
		if(!CheckField()){	return;	}
		if(!confirm('등록하시겠습니까?')){
			return;
		}
		fm.target = "i_no"
		fm.submit();
	}

	//수정
	function TaxRateUp(){
		var fm = document.form1;
		fm.cmd.value = "u";		
		if(fm.reg_dt.value==""){	alert("등록만이 가능합니다.");	return;	}
		if(!CheckField()){	return;	}
		if(!confirm('수정하시겠습니까?')){
			return;
		}
		fm.target = "i_no";
		fm.submit();
	}

	function ClearM(){
		var fm = document.form1;
		fm.tax_nm.value = '';
		fm.dpm.value = '';
		fm.rate_st1.value = '';
		fm.rate_st2.value = '';				
		fm.tax_st_dt.value = '';
		fm.tax_rate.value = '';
		fm.reg_dt.value = '';		
	}
	
	//입력값 null 체크
	function CheckField(){
		var fm = document.form1;
		if(fm.tax_nm.value==""){	alert("세금명을 입력하십시요");		fm.tax_nm.focus();	return false;	}
		if(fm.tax_st_dt.value==""){	alert("기준일자을 입력하십시요");	fm.tax_st_dt.focus();	return false;	}
		if(fm.tax_rate.value==""){	alert("세율을 입력하십시요");			fm.tax_rate.focus();	return false;	}						
		return true;
	}
	
//-->
</script>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
%>
<form action="tax_rate_sc_a.jsp" name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="reg_dt" value="">
<table border=0 cellspacing=0 cellpadding=0 width=98%>
	<tr>
		<td>
			<iframe src="/acar/con_tax/tax_rate_sc_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>" name="i_no" width="100%" height="600" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling='yes' marginwidth='0' marginheight='0'></iframe>
		</td>
	</tr>
    <tr>        
        <td></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>			
    <tr>		
        <td> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>					
                    <td class='line' width="100%"> 
                        <table  border=0 cellspacing=1 width="100%">
                            <tr> 
                                <td class=title>세금명</td>
                                <td>&nbsp; 
                                    <input type="text" name="tax_nm" size="10" value="" class="text">
                                </td>
                                <td class=title>배기량</td>
                                <td>&nbsp; 
                                    <select name="dpm">
                                      <option value="0"></option>
                                      <option value="3">2000CC초과</option>
                                      <option value="2">2000CC이하</option>
                                      <option value="1">1500CC이하</option>
                                      <option value="4">800CC이하</option>
                                    </select>
                                </td>
                                <td class=title>용도별</td>
                                <td>&nbsp; 
                                    <select name="rate_st1">
                                      <option value="0"></option>
                					  <%for(int i=1; i < 7; i++){%>
                                      <option value="<%=i%>" ><%=i%>년이하</option>
                					  <%}%>
                                    </select>
                                </td>
                                <td class=title>경과월수</td>
                                <td>&nbsp; 
                                    <select name="rate_st2">
                                      <option value="0"></option>
                					  <%for(int i=1; i < 13; i++){%>
                                      <option value="<%=i%>"><%=i%>월</option>
                					  <%}%>
                                    </select>
                                </td>
                                <td class=title >기준일자</td>
                                <td>&nbsp; 
                                    <input type="text" name="tax_st_dt" value="" size="12" class="text" onBlur='javscript:this.value = ChangeDate(this.value);'>
                                </td>
                                <td class=title >세율</td>
                                <td>&nbsp; 
                                    <input type="text" name="tax_rate" size="6" class="text_p">%</td>
                            </tr>
                        </table>
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
            <%//if(auth_rw.equals("R/W")){%>
            <a href="javascript:TaxRateReg()"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a> 
            <a href="javascript:TaxRateUp()"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a> 
            <a href="javascript:ClearM()"><img src=../images/center/button_init.gif border=0 align=absmiddle></a> 
            <%}%>
    	  </td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>