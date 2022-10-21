<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"2":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String t_wd = request.getParameter("bank_nm")==null?"":request.getParameter("bank_nm");
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String bank_nm = request.getParameter("bank_nm")==null?"":request.getParameter("bank_nm");
	String fund_yn = request.getParameter("fund_yn")==null?"":request.getParameter("fund_yn");
	
	int  cltr_rat = request.getParameter("cltr_rat")==null?0:Util.parseInt(request.getParameter("cltr_rat"));  //롯데오토리스에서만 사용 (202204)
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function search(){
		var fm = document.form1;
		fm.submit();
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}		
	
	
	//대출의뢰 선택
	function loan_confirm(){
		var fm1= document.form1;	
		var fm = i_no.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "cho_id"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("대출신청할 계약을 선택하세요.");
			return;
		}	
		
		
		fm.target = "_blank";
		fm.action = "bank_doc_reg_cg.jsp?cltr_rat="+fm1.cltr_rat.value+"&exp_dt="+fm1.exp_dt.value+ "&lend_int=" + fm1.lend_int.value+ "&lend_cond=" +fm1.lend_cond.value+ "&doc_id=" +fm1.doc_id.value+ "&bank_id=" +fm1.r_bank_id.value+ "&fund_yn=" +fm1.fund_yn.value + "&bank_nm=" +fm1.bank_nm.value ;		
		fm.submit();
		window.close();
	}			
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body>
<form name='form1' action='find_cont_search_in.jsp' method='post' target='i_no'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='r_bank_id' value='<%=bank_id%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
<input type='hidden' name='bank_nm' value='<%=bank_nm%>'>
<input type='hidden' name='fund_yn' value='<%=fund_yn%>'>
<input type='hidden' name='cltr_rat' value='<%=cltr_rat%>'>
<table border="0" cellspacing="0" cellpadding="0" width=830>
    <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1><span class=style5>계약내역조회</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td width=200>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_day_dc.gif align=absmiddle>&nbsp;
                      <input type='text' name='exp_dt' size='12' value='<%=Util.getDate()%>' maxlength='10' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'></td> 
                    </td>
                    <td width=270><img src=../images/center/arrow_gys.gif align=absmiddle>&nbsp;
                      <input type="text" name="t_wd" value='<%=t_wd%>' size="15" class="text" readonly >
                      <input type="text" name="lend_int" size="10" class="text" > (%)
                    </td>
                    <td><img src=../images/center/arrow_shjg.gif align=absmiddle>&nbsp;
                     <select name='lend_cond'>
                        <option value='1' selected>원리금균등</option>
                        <option value='2' >원금균등</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
                      당월 
                      <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
                      조회기간 </td> 
                    <td> 
                      <select name="gubun2">
                 <!--       <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>계약일</option> -->
                        <option value="1" <%if(gubun2.equals("2"))%>selected<%%>>출고예정일</option>
                      
                      </select>&nbsp;			
                      <input type="text" name="st_dt" value='<%=st_dt%>' size="11" class="text">
                      ~ 
                      <input type="text" name="end_dt" value='<%=end_dt%>' size="11" class="text">
                    </td>
                    <td colspan=2 >     
                      <a href='javascript:search()'><img src=../images/center/button_search.gif border=0 align=absmiddle></a> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><iframe src="./find_cont_search_in.jsp?r_bank_id=<%=bank_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&t_wd=<%=t_wd%>" name="i_no" width="920" height="530" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
    </tr>
    <tr>
        <td style='height:5'></td>
    </tr>
    <tr> 
        <td align="center"><a href="javascript:loan_confirm()"><img src=../images/center/button_conf.gif align=absmiddle border=0></a>&nbsp;&nbsp;<a href="javascript:window.close()"><img src=../images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>
