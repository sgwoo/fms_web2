<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"3":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	Vector fines = FineDocDb.getFineDocLists("관리", br_id, gubun1, gubun2, gubun3, gubun4, "", st_dt, end_dt, s_kd, t_wd, sort, asc);
	int fine_size = fines.size();
	
	int sub_size = 0;
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_ts.css">

<style type="text/css">
    .tr-top td {
    	border-top: 0.5px solid #b0baec !important;
    }
    .tr-left tr:nth-child(1), td:nth-child(1) {
    	border-left: 0.5px solid #b0baec !important;
    }
    .table-t td {
    	border-right: 0.5px solid #b0baec !important;
    	border-bottom: 0.5px solid #b0baec !important;
    }
    .left_p {
    	padding-left: 10px;
    	padding-right: 10px;
    }
</style>
</head>

<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}	
		}
		return;
	}	
	
//-->
</script>
<body>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='doc_cnt' value=''>
<input type='hidden' name='fee_size' value='<%=fine_size%>'>
<input type='hidden' name='doc_id' value=''>
<input type='hidden' name='gov_nm' value=''>
<table class="table-t" border="0" cellspacing="0" cellpadding="0" width='100%' style="margin-top: 10px;">
	<thead>
		<tr class="tr-left tr-top">
			<td class='title' width="2%"><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
	        <td class='title' width="3%">연번</td>
	        <td class='title' width="9%">문서번호</td>
	        <td class='title' width="9%">시행일자</td>
	        <td class='title' width="15%">수신처</td>
	        <td class='title' width="*%">문서24 기관명</td>
	        <td class='title' width="3%">건수</td>
	        <td class='title' width="7%">인쇄일자</td>
	        <td class='title' width="3%">공문</td>
<!-- 	        <td class='title' width="3%">이의<br>신청서</td> -->
	        <td class='title' width="3%">PDF</td>
	        <td class='title' width="7%">등록자</td>
	        <td class='title' width="7%">등록일</td>
	        <td class='title' width="4%">처리</td>
		</tr>
	</thead>
	<tbody>
		<%for(int i = 0 ; i < fine_size ; i++){
  			Hashtable ht = (Hashtable)fines.elementAt(i);%>
				<tr class="tr-left">
					<td align='center'>
			          	<input type="checkbox" name="ch_l_cd" value="<%=i%>">
			          	<input type='hidden' name='ch_doc_id' value='<%=ht.get("DOC_ID")%>'>
			          	<input type='hidden' name='ch_cnt' value='<%=ht.get("CNT")%>'>
			          	<input type='hidden' name='ch_gov_nm' value='<%=ht.get("GOV_NM")%>'>
			         </td>
                    <td align='center'><%=i+1%></td>
                    <td align='center'><a href="javascript:parent.view_fine_doc('<%=ht.get("DOC_ID")%>')" onMouseOver="window.status=''; return true"><span title='<%=ht.get("DOC_ID")%>'><%=ht.get("DOC_ID")%></span></a></td>
                    <td align='center'><%=AddUtil.getDate3(String.valueOf(ht.get("DOC_DT")))%></td>
                    <td align='center'><a href="javascript:parent.view_fine_gov('<%=ht.get("GOV_ID")%>');"><span title='<%=ht.get("GOV_NM")%>'><%=Util.subData(String.valueOf(ht.get("GOV_NM")), 18)%></span></a></td>
                    <td align='left'><span class="left_p" title='<%=ht.get("GOV_NM2")%>'><%=ht.get("GOV_NM2")%></span></td>
                    <%-- <td align='left'>&nbsp;<%=ht.get("GOV_NM2")%></td> --%>
                    <td align="center"><%=ht.get("CNT")%>건</td>
                    <td align="center"><span title="<%=c_db.getNameById(String.valueOf(ht.get("PRINT_ID")), "USER")%>"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PRINT_DT")))%></span></td>
                    <td align='center'><a href="javascript:parent.FineDocPrint('<%=ht.get("DOC_ID")%>');"><img src=/acar/images/center/button_in_print.gif align=absmiddle border=0></a></td>
<%--                     <td align='center'><a href="javascript:parent.ObjectionPrint('<%=ht.get("DOC_ID")%>');"><img src=/acar/images/center/button_in_print.gif align=absmiddle border=0></a></td> --%>
                    <td align='center'><a href="javascript:view_pdf('<%=ht.get("DOC_ID")%>', '<%=ht.get("GOV_NM")%>');">
                    	<img src="/images/esti_detail.gif" width="14" height="15" align="absmiddle" border="0" alt="pdf 저장">
                    </a></td>
                    <td align="center"><%=c_db.getNameById(String.valueOf(ht.get("REG_ID")), "USER")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
                    <td align="center"><!-- 처리유형추가(20180726) -->
                    	<%=ht.get("COMPL_ETC")%>
                    </td>
				</tr>
			<%sub_size = sub_size + Util.parseInt(String.valueOf(ht.get("CNT")));
		}%>
  		<%if(fine_size==0){%>
               <tr> 
                   <td  align='center' colspan="13">등록된 데이타가 없습니다.</td>
               </tr>
        <%}%>
	</tbody>
</table>
<input type='hidden' name='sub_size' value='<%=sub_size%>'>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	var fm = document.form1;
	var fm2 = parent.document.form1;

	<%if(fine_size > 0){%>
		te = parent.document.form1.doc_print_st;
		te.length = <%= (fine_size/10)+2 %>;
		te.options[0].value = '';
		te.options[0].text = '선택';
		<%	int max_num = 20;
				int te_num = 0;
				for(int i=0; i<fine_size; i+=max_num){
					int start_num 	= i+1;
					int end_num 	= i+max_num;
					if(end_num>fine_size) end_num = fine_size;  
					te_num++;
		%>
		te.options[<%=te_num%>].value = '<%=start_num%>~<%=end_num%>';
		te.options[<%=te_num%>].text  = '<%=start_num%>~<%=end_num%>';
		<%	}%>
		te.length = <%= te_num+1 %>;
	<%}%>
	
	function doc_check_set(){
		
		var start_num 	= 0;
		var end_num 	= 0;
		
		if(fm2.doc_print_st.value == '' && toInt(fm2.d_start_num.value) >0){
			start_num 	= toInt(fm2.d_start_num.value);
			end_num 		= toInt(fm2.d_end_num.value);
		}else{
			var select_nums = fm2.doc_print_st.value.split("~");
			start_num 	= toInt(select_nums[0]);
			end_num 		= toInt(select_nums[1]);
		}
		
		if(start_num >0 && end_num>0){
			//초기화
			var len = fm.elements.length;
			for(var i=0; i<len; i++){
				var ck = fm.elements[i];
				if(ck.checked == true){
					ck.click();
				}
			}
			
			/* if((end_num+1-start_num) > 20){
				alert('20건 이상입니다.');	
				return;
			} */	
			
			//선택별 처리
			for(var i=start_num-1 ; i<end_num ; i++){
				fm.ch_l_cd[i].checked = true;
			}
		}
	}
	
	function view_pdf(doc_id, gov_nm){
		var fm = document.form1;
		var len=fm.elements.length;

		fm.doc_id.value = doc_id;
		fm.gov_nm.value = gov_nm;
		
		fm.target = "_blank";
		fm.action = "fine_doc_pdf.jsp";
		fm.submit();
	}
//-->
</script>
</body>
</html>
