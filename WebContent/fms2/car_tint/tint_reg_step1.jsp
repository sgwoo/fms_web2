<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.tint.*, acar.car_office.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "07", "03", "01");	
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	CodeBean[] codes = c_db.getCodeAll("0015");
	int c_size = codes.length;
%>

<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	

	//용품업체 조회
	function search_off()
	{
		var fm = document.form1;	
		window.open("/acar/cus0601/cus0603_frame.jsp?from_page=/fms2/tint/tint_reg_step1.jsp&t_wd="+fm.off_nm.value, "SERV_OFF", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//용품업체 보기
	function view_off()
	{
		var fm = document.form1;
		if(fm.off_id.value == ""){ alert("선택된 용품업체가 없습니다."); return;}
		window.open("/acar/cus0601/cus0603_d_frame.jsp?from_page=/fms2/consignment/cons_i_c.jsp&off_id="+fm.off_id.value, "SERV_OFF", "left=10, top=10, width=900, height=260, scrollbars=yes, status=yes, resizable=yes");
	}		
		

	
	function save(){
		var fm = document.form1;
		
		if(fm.off_id.value == "")			{ 	alert("선택된 용품업체가 없습니다."); 		return;	}
		if(fm.req_id.value == "")			{ 	alert("의뢰자를 입력하십시오."); 		return;	}	

		if(fm.com_nm.value == "")			{ 	alert("상품명을 입력하십시오."); 		return;	}
		
		if(fm.tint_su.value == "" || fm.tint_su.value == "0"){ 	alert("수량을 입력하십시오."); 			return;	}	
	
		if(fm.sup_est_dt.value == ''){	alert('작업마감요청일시를 입력하여 주십시오.');		fm.sup_est_dt.focus(); 		return;		}
		
		fm.tint_amt.value = parseDecimal( toInt(parseDigit(fm.b_tint_amt.value)) * toInt(parseDigit(fm.tint_su.value)) / 1.1 );
				
		if(confirm('등록하시겠습니까?')){		
			fm.action='tint_reg_step1_a.jsp';
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}		
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
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
 <input type='hidden' name='tint_st' value='5'><!--기타용품-->
 <input type='hidden' name='tint_amt' value='0'>
 
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>협력업체 > 용품관리 ><span class=style5>대량용품의뢰등록</span></span></td>
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
                    <td width='13%' class='title'>용품업체</td>
                    <td>&nbsp;
        			  <input type='text' name="off_nm" value='' size='30' class='text'>
        			  <input type='hidden' name='off_id' value=''>
        			  <span class="b"><a href="javascript:search_off()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_search.gif"  border="0" align=absmiddle></a></span>
        			  <span class="b"><a href="javascript:view_off()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_in_see.gif"  border="0" align=absmiddle></a></span>
        			</td>
                    <td width='13%' class='title'>의뢰자</td>
                    <td width="37%">&nbsp;
                      <select name='req_id'>
                        <option value="">선택</option>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID"))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}%>
                      </select></td>			
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td></td>
	</tr>
	<tr>
	    <td style='background-color:e5e5e5; height:1'></td>
	</tr>
	<tr>
	    <td></td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>용품요청내역</span></td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td width='13%' class='title'>상품명</td>
                    <td>&nbsp;
                        <input type='text' name='com_nm' size='70' value='' class='default' >
                    </td>
                </tr>            
                <tr> 
                    <td width='13%' class='title'>모델명</td>
                    <td>&nbsp;
                        <input type='text' name='model_nm' size='105' value='' class='default' >
                    </td>
                </tr>            
                <tr>
                    <td class=title>수량</td>
                    <td>&nbsp;
        		<input type='text' name='tint_su' size='3' value='' class='defaultnum' >개
        	    </td>
                </tr>
                <tr>
                    <td class=title>단가</td>
                    <td>&nbsp;
        		개당 <input type='text' name='b_tint_amt' size='6' value='' class='defaultnum' >원 (부가세포함가)
        	    </td>
                </tr>
                <tr>
                    <td class=title>비고</td>
                    <td>&nbsp;
        		<textarea name="sup_etc" cols="105" rows="4" class="default"></textarea>
        	    </td>
                </tr>
                <tr>
                    <td class=title style='height:36'>작업마감<br>요청일시</td>
                    <td>&nbsp;
        		<input type='text' size='12' name='sup_est_dt' maxlength='12' class='default' value='' onBlur='javscript:this.value = ChangeDate(this.value);'>
        		<input type='text' size='2' name='sup_est_h' class='default' value=''>시
        	    </td>
                </tr>	
    		</table>
	    </td>
	</tr> 		
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>				
	 <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>
	 <tr>
	    <td align="center">&nbsp;<a href="javascript:window.save();"><img src="/acar/images/center/button_reg.gif"  border="0" align=absmiddle></td>
	</tr>
	<% } %>		
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>				
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	
//-->
</script>
</body>
</html>