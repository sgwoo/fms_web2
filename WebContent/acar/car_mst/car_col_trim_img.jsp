<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*, acar.car_office.* ,acar.common.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%

	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");
	String car_c 		= request.getParameter("car_c")		==null?"":request.getParameter("car_c");
	String car_u_seq 		= request.getParameter("car_u_seq")	==null?"":request.getParameter("car_u_seq");
	String car_c_seq 		= request.getParameter("car_c_seq")	==null?"":request.getParameter("car_c_seq");
	
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarMstDatabase cmb = CarMstDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//색상이미지 등록
	String content_code = "CAR_COL";
	String content_seq  = car_comp_id+"^"+code+"^"+car_u_seq+"^"+car_c_seq;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
	int attach_vt_size = attach_vt.size();	
	
	//자동차회사 조회
	CarCompBean cc_r[] = umd.getCarCompAll(car_comp_id);
	cc_bean=cc_r[0];
	
	//차명 조회
	CarMstBean cm_r2 [] = cmb.getCarKindAll(car_comp_id);
	cm_bean=cm_r2[0];
		
	//차명 조회
		String car_cd = cmb.getCarNm(car_comp_id, code);
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style type="text/css">
font{
	font-size: 13px !important;
	font-weight: bold;
}
.search-area{margin: 0px !important;}
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script type="text/javascript">

//색상이미지 등록
function save(){
	fm = document.form1;		
	if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
	fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact_col.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.CAR_COL%>";		
	fm.target = "_blank";
	fm.submit();
}
</script>

</head>
<body>
<form name="form1" method="POST" enctype="multipart/form-data">
<%-- <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_comp_id" value="<%=car_comp_id%>">
<input type="hidden" name="car_cd" value="<%=code%>"> --%>
	<table border=0 cellspacing=0 cellpadding=0 width="100%" class="search-area">
		<tr>
			<td>
				<table width=100% border=0 cellpadding=0 cellspacing=0>
					<tr>
						<td class="navigation">&nbsp;<span class=style1>MASTER>색상관리> <span class=style5>색상 이미지 등록 및 삭제</span>
						</span></td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class=h></td>
		</tr>
		<tr>
	    	<td>
			    &nbsp;<label><i class="fa fa-check-circle"></i> 자동차 회사 : </label><%= cc_bean.getNm() %>
			</td>
	    </tr>
		<tr>
	    	<td>
	    	    &nbsp;<label><i class="fa fa-check-circle"></i> 차명 : </label><%=car_cd%><br>
	    	</td>
	    </tr>
		<tr>
	    	<td>
			    &nbsp;<label><i class="fa fa-check-circle"></i> 색상 : </label><%=car_c%>
			 </td>
	    </tr>
		<tr>
			<td class=h></td>
		</tr>
		<tr>
			<td><%
					 //색상이미지 등록
					if(attach_vt_size > 0){
						for (int j = 0 ; j < attach_vt_size ; j++){
							Hashtable ht = (Hashtable)attach_vt.elementAt(j);%>
						<img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" border="0" width="60" height="20">
						<input type="button" class="button" value="삭제" onclick="window.open('https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>')">
                    <%}
					}else{%>
				&nbsp;<input type="file" name="file" size="35" class=text>
				<input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=content_seq%>'>
				<input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.CAR_COL%>'>&nbsp;
				<input type="button" class="button" value="등록" onclick="javascript:save();">
				<%} %>
			</td>
		</tr>
		<tr>
			<td class=h></td>
		</tr>
	</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize>
</body>
</html>