<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*"%>

<%
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String content_st 	= request.getParameter("content_st")==null?"":request.getParameter("content_st");
	
	System.out.println("/acar/secondhand_hp/esti_doc_select_print.jsp");
	System.out.println("user_id="+user_id);	
	System.out.println("content_st="+content_st);		
	System.out.println("vid="+request.getParameterValues("ch_l_cd"));	
		
	if(String.valueOf(request.getParameterValues("ch_l_cd")).equals("") || String.valueOf(request.getParameterValues("ch_l_cd")).equals("null")){
		out.println("선택된 견적이 없습니다.");
		return;
	}	
		
	String vid[] = request.getParameterValues("ch_l_cd");
	int vid_size = vid.length;
	
	int img_width 	= 680;
	int img_height 	= 1009;
	
	String include_page = "";
	
//	System.out.println("[신차견적서 일괄인쇄] v_size="+v_size+", user_id="+user_id);
%>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
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
        -webkit-margin-before: 0mm; /*상단*/
		-webkit-margin-end: 0mm; /*우측*/
		-webkit-margin-after: 0mm; /*하단*/
		-webkit-margin-start: 0mm; /*좌측*/
}

</style>

</head>
<body>
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30"> 
</object> 
<%	for(int i=0; i < vid_size; i++){
		String est_id = vid[i];
		
		EstimateBean bean = e_db.getEstimateCase(est_id);
		
		int opt_size = AddUtil.lengthb(bean.getOpt());%>

<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
<%
if(content_st.equals("sh_rm")){
	include_page = "esti_print_rm_new.jsp";
}else if(content_st.equals("sh_fms_ym")){
	include_page = "estimate_fms_ym.jsp";	
}else{
	include_page = "estimate_fms.jsp";	
}
%>
	<tr>
	    <!-- 견적서 인쇄페이지 -->
		<td height=1009>
		    <%-- <%if(content_st.equals("sh_rm")){%>
		    <jsp:include page="esti_print_rm_new.jsp" flush="true">
		    <%}else if(content_st.equals("sh_fms_ym")){%>
		    <jsp:include page="esti_print_fms_ym.jsp" flush="true">
		    <%}else{%>
		    <%}%> --%>
		    <jsp:include page="<%=include_page%>" flush="true">
				<jsp:param name="from_page" value="/acar/estimate_mng/esti_mng_u.jsp" />
				<jsp:param name="est_id" value="<%=est_id%>" />
				<jsp:param name="acar_id" value="<%=user_id%>" />
				<jsp:param name="mail_yn" value="Y" />
				<jsp:param name="opt_chk" value="<%=bean.getOpt_chk()%>" />
				<jsp:param name="select_print_yn" value="Y"/>
            </jsp:include>
			<!-- 견적서 인쇄페이지 -->
		</td>
	</tr>
</table>

<p style='page-break-before:always'><br style="height:0; line-height:0"></P>
<%		if(bean.getDoc_type().equals("")){//필요서류 미표기%>

<%		}%>


<%		if(!bean.getOpt_chk().equals("1")){				//매입옵션 있음%>
<%			if((i+1) < vid_size){						//마지막페이지가 아님%>
<%				if(!bean.getVali_type().equals("1")){	//메이커D/C 변경 가능성 언급%>
<%					if(opt_size > 56){					//옵션이 한줄이상%>
<%						if(i==4){%>

<%						}else{%>
						<br>
<%						}%>
<%					}else{%>
						<br><br>
<%					}%>
<%				}%>
<%			}%>
<%		}%>	


<%	} //for end%>
</body>
</html>
<script>
select_onprint();

function IE_Print(){
	factory.printing.header = ""; //폐이지상단 인쇄
	factory.printing.footer = ""; //폐이지하단 인쇄
	factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
	factory.printing.leftMargin = 0; //좌측여백   
	factory.printing.topMargin = 0; //상단여백    
	factory.printing.rightMargin = 0; //우측여백
	factory.printing.bottomMargin = 0; //하단여백
	factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}

function select_onprint(){
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
