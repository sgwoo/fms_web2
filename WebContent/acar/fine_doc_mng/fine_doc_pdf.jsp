<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>	
<jsp:useBean id="FineDocListBn" scope="page" class="acar.forfeit_mng.FineDocListBean"/>
<%@ include file="/acar/cookies.jsp" %>
	
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>

<style>

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

body {
    	-webkit-print-color-adjust: exact; 
    	-ms-print-color-adjust: exact; 
    	color-adjust: exact;
    	/* transform: scale(.9); */    	
        /* margin으로 프린트 여백 조정 */
        /* IE */
        margin: 0mm 0mm 0mm 0mm;
        
        /* CHROME */
        -webkit-margin-before: 8mm; /*상단*/
		-webkit-margin-end: 0mm; /*우측*/
		-webkit-margin-after: 0mm; /*하단*/
		-webkit-margin-start: 0mm; /*좌측*/
}

</style>
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
<body leftmargin="15" topmargin="1" onload="javascript:onprint();">
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

	
<%
	String user_id 	 = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String find_type = request.getParameter("find_type")==null?"":request.getParameter("find_type");
	String doc_id	= request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String doc_dt 	= "";
	
	AddForfeitDatabase afm_db = AddForfeitDatabase.getInstance();
	UserMngDatabase u_db = UserMngDatabase.getInstance();
	
	String list_size = "";
	String img_url = "";
	String gov_nm = request.getParameter("gov_nm")==null?"":request.getParameter("gov_nm");
	
	double img_width 	= 690;
	double img_height 	= 1009;	

	img_url		= doc_id;
		
	if(!doc_id.equals("")){
	
		FineDocBn = FineDocDb.getFineDoc(doc_id);
		FineGovBn = FineDocDb.getFineGov(FineDocBn.getGov_id());
		doc_dt = FineDocBn.getDoc_dt();

		//과태료리스트
		Vector FineList = FineDocDb.getFineDocLists(doc_id);
			

%>
<!-- 과태료공문 -->
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" class="a4"> 
	<tr>
		<td height=1009>
			<jsp:include page="/acar/fine_doc_mng/i_fine_doc_print.jsp" flush="true">
	          	<jsp:param name="doc_id" value="<%=doc_id%>"/>
	          	<jsp:param name="user_id" value="<%=user_id%>"/>
	          	<jsp:param name="mode" value="fine"/>
			</jsp:include>
		</td>
	</tr>
</table>

  
<%
			if(FineList.size()>0){
				for(int i=0; i<FineList.size(); i++){ 
					FineDocListBn = (FineDocListBean)FineList.elementAt(i); 
					String rent_mng_id 		= FineDocListBn.getRent_mng_id();
					String rent_l_cd 		= FineDocListBn.getRent_l_cd();
					String rent_mng_id2 	= FineDocListBn.getSub_rent_mng_id();
					String rent_l_cd2 		= FineDocListBn.getSub_rent_l_cd();
					String client_id 		= FineDocListBn.getClient_id();
					String vio_dt 			= FineDocListBn.getVio_dt();
					String rent_s_cd 		= FineDocListBn.getRent_s_cd();
					String car_mng_id		= FineDocListBn.getCar_mng_id();
					String car_st			= FineDocListBn.getCar_st();
					String rent_st			= FineDocListBn.getRent_st();
					String rent_start_dt	= FineDocListBn.getRent_start_dt();
					String rent_end_dt		= FineDocListBn.getRent_end_dt();
					String file_name		= FineDocListBn.getFile_name();
					String note				= FineDocListBn.getNote();
					int    seq_no 			= FineDocListBn.getSeq_no();
					
					if(rent_st.equals("")){
						//대여기간에 맞는 과태료 입력 확인
						rent_st = afm_db.getFineSearchRentst(rent_mng_id, rent_l_cd, vio_dt);
					}
					if(!rent_s_cd.equals("")){
						//대여기간에 맞는 과태료 입력 확인
						rent_st = afm_db.getFineSearchRentst(rent_mng_id2, rent_l_cd2, vio_dt);
					}
%>

<!--과태료 청구서 스캔파일-->
			<jsp:include page="i_fine_fscan_print.jsp" flush="true">
          <jsp:param name="rent_mng_id" value="<%=rent_mng_id%>"/>
          <jsp:param name="rent_l_cd" value="<%=rent_l_cd%>"/>
          <jsp:param name="client_id" value="<%=client_id%>"/>
          <jsp:param name="car_mng_id" value="<%=car_mng_id%>"/>
          <jsp:param name="mode" value="fine"/>
         	<jsp:param name="doc_id" value="<%=doc_id%>"/>
         	<jsp:param name="vio_dt" value="<%=vio_dt%>"/>
         	<jsp:param name="seq_no" value="<%=seq_no%>"/>
         	<jsp:param name="file_name" value="<%=file_name%>"/>
         	<jsp:param name="note" value="<%=note%>"/>
			</jsp:include>


<!--자동차대차이용계약서-->
<%				if(!rent_s_cd.equals("")){%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" class="a4">
	<tr>
		<td height=1009>
			
			<jsp:include page="i_fine_scont_print.jsp" flush="true">
          <jsp:param name="c_id" value="<%=car_mng_id%>"/>
          <jsp:param name="s_cd" value="<%=rent_s_cd%>"/>
          <jsp:param name="mode" value="fine"/>
			</jsp:include>
		</td>
	</tr>
</table>

<!--자동차대여이용계약서-->
<%				}else{%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" class="a4">
	<tr>
		<td height=1009>
			<jsp:include page="i_fine_lcont_print.jsp" flush="true">
          <jsp:param name="rent_mng_id" value="<%=rent_mng_id%>"/>
          <jsp:param name="rent_l_cd" value="<%=rent_l_cd%>"/>
          <jsp:param name="rent_st" value="<%=rent_st%>"/>
          <jsp:param name="doc_dt" value="<%=doc_dt%>"/>
          <jsp:param name="rent_start_dt" value="<%=rent_start_dt%>"/>
          <jsp:param name="rent_end_dt" value="<%=rent_end_dt%>"/>
          <jsp:param name="vio_dt" value="<%=vio_dt%>"/>
          <jsp:param name="mode" value="fine"/>
			</jsp:include>
		</td>
	</tr>
</table>
<%				}%>


<!--계약서외 스캔파일-->
			<jsp:include page="i_fine_lscan_print.jsp" flush="true">
          <jsp:param name="rent_mng_id" value="<%=rent_mng_id%>"/>
          <jsp:param name="rent_l_cd" value="<%=rent_l_cd%>"/>
          <jsp:param name="rent_mng_id2" value="<%=rent_mng_id2%>"/>
          <jsp:param name="rent_l_cd2" value="<%=rent_l_cd2%>"/>
          <jsp:param name="client_id" value="<%=client_id%>"/>
          <jsp:param name="car_mng_id" value="<%=car_mng_id%>"/>
          <jsp:param name="rent_s_cd" value="<%=rent_s_cd%>"/>
          <jsp:param name="rent_st" value="<%=rent_st%>"/>
          <jsp:param name="vio_dt" value="<%=vio_dt%>"/>
          <jsp:param name="mode" value="fine"/>
			</jsp:include>


<%			}
			}
		}
%>

</body>
<script>

function IE_Print() {
	factory1.printing.header = ""; //폐이지상단 인쇄
	factory1.printing.footer = ""; //폐이지하단 인쇄
	factory1.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
// 	factory1.printing.leftMargin = 15.0; //좌측여백   
// 	factory1.printing.rightMargin = 0.0; //우측여백
// 	factory1.printing.topMargin = 17.0; //상단여백    
// 	factory1.printing.bottomMargin = 0.0; //하단여백
	factory1.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}

function onprint(){
	document.title = '<%=doc_id%>_<%=gov_nm%>';
	var userAgent = navigator.userAgent.toLowerCase();
	if (userAgent.indexOf("edge") > -1) {
		window.print();
	} else if (userAgent.indexOf("whale") > -1) {
		window.print();
	} else if (userAgent.indexOf("chrome") > -1) {
		window.print();
	} else if (userAgent.indexOf("firefox") > -1) {
		window.print();
	} else if (userAgent.indexOf("safari") > -1) {
		window.print();
	} else {
		IE_Print();
	}
}

</script>
</html>

