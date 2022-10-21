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
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	String dt = request.getParameter("dt")==null?"3":request.getParameter("dt");
%>

<html>
<head><title>FMS</title>
<script language="JavaScript" src="/include/common.js"></script>
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
	
	
	function search_ok(ins_com_id, ins_com, ins_f_nm, ins_nm, ins_addr, zip){
		var fm = opener.document.form1;
		fm.gov_id.value 	= ins_com_id;
		fm.gov_nm.value 	= ins_f_nm;
		fm.ins_com.value 	= ins_com;
		fm.mng_nm.value 	= ins_nm;
		fm.t_addr.value 	= ins_addr;
		fm.t_zip.value 		= zip;
	
		//opener.find_gov_search();
		
		window.close();
	}
	
	function search_dir_ok(cho_id, ins_com_id, ins_com, ins_f_nm, ins_nm, ins_addr, zip, app_docs, bus_id2){
		var o_fm = opener.document.form1;
		o_fm.gov_id.value 	= ins_com_id;
		o_fm.gov_nm.value 	= ins_f_nm;
		o_fm.ins_com.value 	= ins_com;
		o_fm.mng_nm.value 	= ins_nm;
		o_fm.t_addr.value 	= ins_addr;
		o_fm.t_zip.value 	= zip;
		o_fm.app_docs.value = app_docs;
		o_fm.b_mng_id.value = bus_id2;
	
		var fm= document.form1;	
		fm.cho_id.value = cho_id;
		fm.target = "c_foot";
		fm.action = "accid_mydoc_reg_sc.jsp";		
		fm.submit();
		
		window.close();
	}	
	
	//휴/대차료 선택
	function loan_confirm(){
		var fm1= document.form1;	
		var fm = i_no.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var ins_com = "";
		
		var o_fm = opener.document.form1;
		
		if(fm.settle_size.value =='0'){
			alert('데이타가 없습니다.');
			return;
		}
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "cho_id"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
					
					var f_txt = idnum.split("^");
					var idx = f_txt[4];
					
					if(cnt == 1 && toInt(fm.settle_size.value) > 1) ins_com = fm.ins_com[idx].value;
					
					if(toInt(fm.settle_size.value) > 1 && cnt > 1){
						
						if(ins_com != fm.ins_com[idx].value){
							alert('같은 보험사를 선택하십시오.');
							return;
						}else{
							ins_com = fm.ins_com[idx].value;
						}
					}
					
					if(cnt==1){
						if(fm.settle_size.value =='1'){
							o_fm.gov_id.value 	= fm.ins_com_id.value;
							o_fm.gov_nm.value 	= fm.ins_f_com.value;
							o_fm.ins_com.value 	= fm.ins_com.value;
							o_fm.mng_nm.value 	= fm.ins_nm.value;
							o_fm.t_addr.value 	= fm.ins_addr.value;
							o_fm.t_zip.value 	= fm.ins_zip.value;		
							o_fm.app_docs.value = fm.ins_app_docs.value;
							o_fm.b_mng_id.value = fm.bus_id2.value;
						}else{
							o_fm.gov_id.value 	= fm.ins_com_id[idx].value;
							o_fm.gov_nm.value 	= fm.ins_f_com[idx].value;
							o_fm.ins_com.value 	= fm.ins_com[idx].value;
							o_fm.mng_nm.value 	= fm.ins_nm[idx].value;
							o_fm.t_addr.value 	= fm.ins_addr[idx].value;
							o_fm.t_zip.value 	= fm.ins_zip[idx].value;	
							o_fm.app_docs.value	= fm.ins_app_docs[idx].value;	
							o_fm.b_mng_id.value = fm.bus_id2[idx].value;						
						}												
					}
				}
			}
		}	
		
		if(cnt == 0){
		 	alert("공문을 발송할 휴/대차료를 선택하세요.");
			return;
		}	
		
		fm.target = "c_foot";
		fm.action = "accid_mydoc_reg_sc.jsp";		
		fm.submit();
		window.close();
	}				
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">

</head>
<body>
<form name='form1' action='find_docreq_search_in.jsp' method='post' target='i_no'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='r_gov_id' value='<%=gov_id%>'>
<input type='hidden' name='cho_id' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1><span class=style5>대차료청구공문 발행의뢰 조회</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
                      당월 
                      <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
                      조회기간 </td> 
                    <td> 
                      <select name="gubun2">
                        <option value="1" <%if(gubun2.equals("2"))%>selected<%%>>발행요청일</option>                     
                      </select>&nbsp;			
                      <input type="text" name="st_dt" value='<%=st_dt%>' size="9" class="text">
                      ~ 
                      <input type="text" name="end_dt" value='<%=end_dt%>' size="9" class="text">
                    </td>
                    <td colspan=2 >     
                      <a href='javascript:search()'><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><iframe src="./find_docreq_search_in.jsp?r_gov_id=<%=gov_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&st_dt=<%=st_dt%>&end_dt=<%=end_dt%>&t_wd=<%=t_wd%>" name="i_no" width="800" height="550" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
    </tr>
    <tr>
        <td>* 같은 보험사로 묶어서 등록하세요.</td>
    </tr>
    <tr> 
        <td align="center">
        	<a href="javascript:loan_confirm()"><img src=/acar/images/center/button_conf.gif align=absmiddle border=0></a>&nbsp;&nbsp;
		<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
	</td>
    </tr>
</table>
</form>
</body>
</html>
