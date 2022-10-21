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
		out.println("���õ� ������ �����ϴ�.");
		return;
	}	
		
	String vid[] = request.getParameterValues("ch_l_cd");
	int vid_size = vid.length;
	
	int img_width 	= 680;
	int img_height 	= 1009;
	
	String include_page = "";
	
//	System.out.println("[���������� �ϰ��μ�] v_size="+v_size+", user_id="+user_id);
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
        /* margin���� ����Ʈ ���� ���� */
        /* IE */
        margin: 0mm 0mm 0mm 0mm;
        
        /* CHROME */
        -webkit-margin-before: 0mm; /*���*/
		-webkit-margin-end: 0mm; /*����*/
		-webkit-margin-after: 0mm; /*�ϴ�*/
		-webkit-margin-start: 0mm; /*����*/
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
	    <!-- ������ �μ������� -->
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
			<!-- ������ �μ������� -->
		</td>
	</tr>
</table>

<p style='page-break-before:always'><br style="height:0; line-height:0"></P>
<%		if(bean.getDoc_type().equals("")){//�ʿ伭�� ��ǥ��%>

<%		}%>


<%		if(!bean.getOpt_chk().equals("1")){				//���Կɼ� ����%>
<%			if((i+1) < vid_size){						//�������������� �ƴ�%>
<%				if(!bean.getVali_type().equals("1")){	//����ĿD/C ���� ���ɼ� ���%>
<%					if(opt_size > 56){					//�ɼ��� �����̻�%>
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
	factory.printing.header = ""; //��������� �μ�
	factory.printing.footer = ""; //�������ϴ� �μ�
	factory.printing.portrait = true; //true-�����μ�, false-�����μ�    
	factory.printing.leftMargin = 0; //��������   
	factory.printing.topMargin = 0; //��ܿ���    
	factory.printing.rightMargin = 0; //��������
	factory.printing.bottomMargin = 0; //�ϴܿ���
	factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
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
