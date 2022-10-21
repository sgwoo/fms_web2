<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*, acar.common.*" %>
<jsp:useBean id="co_bean" class="acar.car_mst.CarColBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"0001":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")==null?"":request.getParameter("code");
	String col_st 		= request.getParameter("col_st")==null?"":request.getParameter("col_st");
	String car_u_seq 	= request.getParameter("car_u_seq")==null?"":request.getParameter("car_u_seq");
	String view_dt 		= request.getParameter("view_dt")==null?"":request.getParameter("view_dt");
	String use_yn 		= request.getParameter("use_yn")==null?"":request.getParameter("use_yn");
	
	
	//옵션관리 리스트	
	CarColBean [] co_r = a_cmb.getCarColListTrim(car_comp_id, code, col_st, use_yn);
	
	//색상표 파일리스트
	Vector scanList = c_db.getAcarAttachFileList("CAR_COL_CAT",car_comp_id+"^"+code+"^%",-1);
	int scanListSize = scanList.size();
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style type="text/css">
.height_td {height:33px;}
select {
	width: 104px !important;
}
.input {
	height: 24px !important;
}
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
	function UpdateCarDcDisp(car_u_seq, car_c_seq, car_c, car_c_p, car_c_dt, use_yn, etc, col_st, jg_opt_st){
	
		var theForm = parent.document.form1;	
		
		theForm.car_u_seq.value 	= car_u_seq;
		theForm.car_c_seq.value 	= car_c_seq;
		theForm.car_c.value 		= car_c;
		theForm.car_c_p.value 		= parseDecimal(car_c_p);		
		theForm.car_c_dt.value 		= ChangeDate3(car_c_dt);		
		theForm.etc.value 		= etc;
		theForm.jg_opt_st.value 	= jg_opt_st;

		if(col_st == '1') 			theForm.col_st[1].selected = true;
		else if(col_st == '2')		theForm.col_st[2].selected = true;
		else if(col_st == '3')		theForm.col_st[3].selected = true;
		else 						theForm.col_st[0].selected = true;
		
		if(use_yn == 'N')			theForm.use_yn[1].selected = true;
		else						theForm.use_yn[0].selected = true;
	}
	
	//스캔삭제
	function scan_del(seq, content_seq, num){
		window.open("https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ="+seq, "SCAN", "left=10, top=10, width=570, height=280, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//파일비고수정
	function file_bigo_update(content_seq, num){
		var fm = document.CarNmForm;
		var file_bigo_before = "";
		var file_bigo_after  = "";
		/* if(num==0){
			file_bigo_before = fm.file_bigo_before.value;
			file_bigo_after	 = fm.file_bigo_after.value; 
		}else{ */
			file_bigo_before = fm.file_bigo_before[num].value;;
			file_bigo_after  = fm.file_bigo_after[num].value;
		//}
		fm.content_seq.value = content_seq;
		fm.etc_content.value = file_bigo_after;
		
		if(file_bigo_before==""){	fm.cmd.value = "file_bigo_i";	}
		else{						fm.cmd.value = "file_bigo_u";	}
		
		fm.submit();
	}
	
	// 선택항목 수정
	function updateCheckedUse(){
		var fm = document.CarNmForm;
		var cnt = 0;
		var len = fm.elements.length;
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == 'check_value'){
				if(ck.checked){
					++ cnt;
				}
			}
		}
		if(cnt == 0){
			alert('색상을 선택해 주세요.');
			return;
		}
		
		fm.cmd.value = "chk_u";
		fm.action = "./car_col_null_ui.jsp";
		fm.method = "POST";
		fm.submit();
	}
	
</script>
</head>
<body>

<form action="./car_col_null_ui.jsp" name="CarNmForm" method="POST" >  
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="car_comp_id" value="<%=car_comp_id%>">
<input type="hidden" name="code" value="<%=code%>">
<input type="hidden" name="content_seq" value="">
<input type="hidden" name="etc_content" value="">
<%	if(co_r.length > 0){%>
<table border=0 cellspacing=0 cellpadding=0 width="880">
    <tr>
        <td class=line colspan="2">            
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
          <%	for(int i=0; i<co_r.length; i++){
			        co_bean = co_r[i];%>
                <tr> 
                    <td align=center width="4%">
                    	<input type="checkbox" name="check_value" value="<%=co_bean.getCar_u_seq()%>_<%=co_bean.getCar_c_seq()%>_<%=co_bean.getCar_c()%>_<%=co_bean.getCar_c_p()%>_<%=AddUtil.ChangeDate2(co_bean.getCar_c_dt())%>_<%=co_bean.getEtc()%>_<%=co_bean.getCol_st()%>_<%=co_bean.getJg_opt_st()%>_''">
                    </td>
                    <td align=center width="4%"><%=i+1%></td>
                    <td align=center width="6%"><%if(co_bean.getCol_st().equals("2")){%>내장<%}else if (co_bean.getCol_st().equals("3")){%>가니쉬<%}else{%>외장<%}%></td>
                    <td align=center width="20%"><a href="javascript:UpdateCarDcDisp('<%=co_bean.getCar_u_seq()%>','<%=co_bean.getCar_c_seq()%>','<%=co_bean.getCar_c()%>','<%=co_bean.getCar_c_p()%>','<%=co_bean.getCar_c_dt()%>','<%=co_bean.getUse_yn()%>','<%=co_bean.getEtc()%>','<%=co_bean.getCol_st()%>','<%=co_bean.getJg_opt_st()%>')" onMouseOver="window.status=''; return true"><%=co_bean.getCar_c()%></a></td>
                    <td align=center width="10%">
                   <%
					 //색상이미지 등록
					String content_code = "CAR_COL";
					String content_seq  = car_comp_id+"^"+code+"^"+co_bean.getCar_u_seq()+"^"+co_bean.getCar_c_seq();
               	
					Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
					int attach_vt_size = attach_vt.size();	
                   
					if(attach_vt_size > 0){
						for (int j = 0 ; j < attach_vt_size ; j++){
							Hashtable ht = (Hashtable)attach_vt.elementAt(j);%>
						<img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" border="0" width="60" height="20">
                    <%}
					}else{%>
						없음
					<%}%>
                    </td>
                    <td align=center width="5%">&nbsp;<%=co_bean.getJg_opt_st()%></td>
                    <td align=right width="7%"><%=AddUtil.parseDecimal(co_bean.getCar_c_p())%>원</td>
                    <td align=center width="*%"><%=co_bean.getEtc()%></td>					
                    <td align=center width="5%"><%=co_bean.getUse_yn()%></td>		
                    <td align=center width="9%"><%=AddUtil.ChangeDate2(co_bean.getCar_c_dt())%></td>			
                </tr>
          <%	}	%>
            </table>
        </td>
    </tr>
    <tr>
       <td colspan="2">
           사용여부 &nbsp;&nbsp;
        <select name="use_yn" class="select">
			<option value="Y">사용</option>
			<option value="N">미사용</option>
		</select>&nbsp;
		<input type="button" class="button" value="선택수정" onclick="javascript:updateCheckedUse();">
       </td>
    </tr>
</table>
<%	}%>
<%if(scanListSize > 0){ %>
<br><br><b>&lt; 색상표 &gt;</b><br>
<table border=0 cellspacing=0 cellpadding=0 width="880">
	<tr>
		<td class=line colspan="2">
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td class="title" width="4%">연번</td>
					<td class="title" width="30%">파일이름</td>
					<td class="title" width="15%">등록일자</td>
					<td class="title" width="*">비고</td>
					<td class="title" width="5%">파일<br>삭제</td>
				</tr>
			<%	for(int i=0; i<scanListSize; i++){ %>
				<%	Hashtable ht2 = (Hashtable)scanList.elementAt(i); %>
				<%	CommonEtcBean etc_bean = new CommonEtcBean();  
					etc_bean = c_db.getCommonEtc("acar_attach_file","content_code","CAR_COL_CAT","content_seq",String.valueOf(ht2.get("CONTENT_SEQ")),"","","","");
				%>
				<tr>
					<td align="center"><%=i+1%></td>
					<td align="center"><a href="javascript:openPopF('<%=ht2.get("FILE_TYPE")%>','<%=ht2.get("SEQ")%>');" title='보기' ><%=ht2.get("FILE_NAME")%></a></td>
					<td align="center"><%=String.valueOf(ht2.get("REG_DATE")).substring(0,10)%></td>
					<td align="left">&nbsp;
						<textarea rows="3" cols="50" name="file_bigo_after"><%=etc_bean.getEtc_content()%></textarea>
						<input type="hidden" name="file_bigo_before" value="<%=etc_bean.getEtc_content()%>">
						<input type="button" class="button" value="비고수정" style="padding: 2px;" onclick="javascript:file_bigo_update('<%=ht2.get("CONTENT_SEQ")%>','<%=i%>');">
					</td>
					<td align="center">
						<a href="javascript:scan_del('<%=ht2.get("SEQ")%>','<%=ht2.get("CONTENT_SEQ")%>','<%=i%>')"><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
					</td>
				</tr>
				<%} %>
			</table>
			<input type="hidden" name="file_bigo_after" value="">
			<input type="hidden" name="file_bigo_before" value="">
		</td>
	</tr>		
</table>
<%} %>                             
</form>
</body>
</html>