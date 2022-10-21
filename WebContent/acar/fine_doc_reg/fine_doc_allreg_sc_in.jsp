<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
		
	
	Vector fines = FineDocDb.getFineDocRegList(gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort, asc);	
	int fine_size = fines.size();
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">

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
    	padding-left: 22px;
    	padding-right: 22px;
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
<table class="table-t" border="0" cellspacing="0" cellpadding="0" width='100%' style="margin-top: 10px;">
	<thead>
		<tr class="tr-left tr-top">
	        <td class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
	        <td class='title'>연번</td>
	        <td class='title'>상호</td>
	        <td class='title'>차량번호</td>
	        <td class='title'>기관명</td>
	        <td class='title'>고지서번호</td>
	        <td class='title'>위반일시</td>
	        <td class='title'>위반내용</td>
	        <td class='title'>등록일</td>
	        <td class='title'>등록자</td>
	        <td class='title'>이의신청</td>
	        <td class='title'>최종이의신청일</td>
		</tr>
	</thead>
	<tbody>
				<%for(int i = 0 ; i < fine_size ; i++){
  					Hashtable ht = (Hashtable)fines.elementAt(i);%>
				<tr class="tr-left">
                    <td align='center'>
                      <input type="checkbox" name="ch_l_cd" value="<%=i%>">
                      <input type='hidden' name='m_id' value='<%=ht.get("RENT_MNG_ID")%>'>
                      <input type='hidden' name='l_cd' value='<%=ht.get("RENT_L_CD")%>'>
                      <input type='hidden' name='c_id' value='<%=ht.get("CAR_MNG_ID")%>'>
                      <input type='hidden' name='seq_no' value='<%=ht.get("SEQ_NO")%>'>
                    </td>
                    <td align='center'><%=i+1%></td>
                    <td align='left'><span class="left_p" title='<%=ht.get("FIRM_NM")%>'><%=ht.get("FIRM_NM")%></span><%if(String.valueOf(ht.get("CAR_ST")).equals("4")){%><font color=red>(월)</font><%}%></td>
                    <td align='left'><span class="left_p" title='<%=ht.get("CAR_NO")%>'><%=ht.get("CAR_NO")%></span></td>
                    <td align='left'><span class="left_p" title='<%=ht.get("GOV_NM")%>'><%=ht.get("GOV_NM")%></span></td>
                    <td align='center'><a href="javascript:parent.view_fine('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("CAR_MNG_ID")%>','<%=ht.get("SEQ_NO")%>')" onMouseOver="window.status=''; return true"><span title='<%=ht.get("PAID_NO")%>'><%=ht.get("PAID_NO")%></span></a></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("VIO_DT")))%></td>	
                    <td align='left'><span class="left_p" title='<%=ht.get("VIO_CONT")%>'><%=ht.get("VIO_CONT")%></span></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
                    <td align="center"><%=ht.get("REG_NM")%></td>
                    <td align="center"><%=ht.get("CNT")%>건</td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("MAX_DOC_DT")))%></td>
				</tr>
			<%		}%>
  		<%if(fine_size==0){%>
               <tr> 
                   <td  align='center' colspan="12">등록된 데이타가 없습니다.</td>
               </tr>
        <%}%>
	</tbody>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--

//-->
</script>
</body>
</html>
