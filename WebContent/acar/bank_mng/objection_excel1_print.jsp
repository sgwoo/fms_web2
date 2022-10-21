<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=objection_excel1_print.xls");
%>
<%@ page import="java.util.*,  acar.util.*"%>
<%@ page import="acar.common.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
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
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
		//대출신청리스트
	Vector FineList = FineDocDb.getBankDocAllLists2(doc_id);
	
	long t_amt1[] = new long[1];
    long t_amt2[] = new long[1];
    long t_amt3[] = new long[1];
    long t_amt4[] = new long[1];
    long t_amt5[] = new long[1];
    long t_amt6[] = new long[1];
    long t_amt7[] = new long[1];
	
	double img_width 	= 680;
	double img_height 	= 1009;
	
	String c_id[] = new String[FineList.size()];
	String l_cd[] = new String[FineList.size()];
	String m_id[] = new String[FineList.size()];
	String c_no[] = new String[FineList.size()];
	
		
	if(FineList.size()>0){
		for(int i=0; i<FineList.size(); i++){ 
			Hashtable ht = (Hashtable)FineList.elementAt(i);
			
			c_id[i] = String.valueOf(ht.get("CAR_MNG_ID"));
			l_cd[i] = String.valueOf(ht.get("RENT_L_CD"));	
			m_id[i] = String.valueOf(ht.get("RENT_MNG_ID"));	
			c_no[i] = String.valueOf(ht.get("CAR_NO"));	
	

	 	}
	} 

		
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script>

window.onbeforeprint = function(){
	//setCookie();
};

function setCookie(cName, cValue, cMinutes){

 	var expire = new Date();
    expire.setDate(expire.getMinutes() + cMinutes);
    cookies = cName + '=' + escape(cValue) + '; path=/ ; domain=.amazoncar.co.kr';
    if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
    document.cookie = cookies;
    
}

// 쿠키 가져오기
function getCookie(cName) {
    cName = cName + '=';
    var cookieData = document.cookie;
    var start = cookieData.indexOf(cName);
    var cValue = '';
    if(start != -1){
        start += cName.length;
        var end = cookieData.indexOf(';', start);
        if(end == -1)end = cookieData.length;
        cValue = cookieData.substring(start, end);
    }
    return unescape(cValue);
}

setCookie('tmp_waste', 'delete', 1);

</script>

</head>
<body leftmargin="15" topmargin="1"  face="바탕">

<form action="" name="form1" method="POST" >
 <table width='<%=img_width +2 %>' border="0" cellpadding="0" cellspacing="0" >
<%

for(int k=0; k<FineList.size(); k++){ 

	String car_mng_id = c_id[k];
	String rent_mng_id = m_id[k];
	String rent_l_cd = l_cd[k];
	String car_no = c_no[k];
	String rent_st = "1";

		int size = 0;

		String content_code = "LC_SCAN";
		String content_seq  = rent_mng_id+rent_l_cd+rent_st;

		Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
		int attach_vt_size = attach_vt.size();

		String file_type1 = "";
		String seq1 = "";
		String file_name1 = "";
		String s_gubun1 = "";
		
		String file_type2 = "";
		String seq2 = "";
		String file_name2 = "";
		String s_gubun2 = "";
		
		for(int j=0; j< attach_vt.size(); j++){
			Hashtable aht = (Hashtable)attach_vt.elementAt(j);   
			
			if((content_seq+17).equals(aht.get("CONTENT_SEQ"))){
				file_name1 = String.valueOf(aht.get("FILE_NAME"));
				file_type1 = String.valueOf(aht.get("FILE_TYPE"));
				seq1 = String.valueOf(aht.get("SEQ"));
				s_gubun1 = String.valueOf(aht.get("FILE_SIZE"));
				
			}else if((content_seq+18).equals(aht.get("CONTENT_SEQ"))){
				file_name2 = String.valueOf(aht.get("FILE_NAME"));
				file_type2 = String.valueOf(aht.get("FILE_TYPE"));
				seq2 = String.valueOf(aht.get("SEQ"));
				s_gubun2 = String.valueOf(aht.get("FILE_SIZE"));

			}
		}
			
			
%>
 <% if ( !seq1.equals("") ) { %> 
	<tr>
		<td height=1039> <!-- cookies 제외 view_normal을 view_normal_email로 -->
			<img src="https://fms3.amazoncar.co.kr/fms2/attach/view_normal_email.jsp?CONTENT_CODE=<%=content_code%>&SEQ=<%=seq1%>&S_GUBUN=<%=s_gubun1%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
			<img src="https://fms3.amazoncar.co.kr/fms2/attach/view_normal_email.jsp?CONTENT_CODE=<%=content_code%>&SEQ=<%=seq2%>&S_GUBUN=<%=s_gubun2%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
		</td>
	</tr>
 <% } %>	
<%}%>
</table>

</form>
</body>
</html>
