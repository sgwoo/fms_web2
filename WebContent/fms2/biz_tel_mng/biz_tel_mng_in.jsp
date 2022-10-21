<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.biz_tel_mng.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun = request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	
	BiztelDatabase biz_db = BiztelDatabase.getInstance();
	
	Vector vt = biz_db.Biz_tel_mng_list(gubun, s_dt, e_dt, s_kd, t_wd, user_id);
	int vt_size = vt.size();
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--

	/* Title ���� */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}
	
	
//-->
</script>

</head>
<body onLoad="javascript:init()">
<form action="" name="form1" method="POST">
  
<table border=0 cellspacing=0 cellpadding=0 width="2300">
    <tr>
        <td>
            <table border="0" cellspacing="0" cellpadding="0" width="100%">
                <tr>
                    <td class=line2 colspan=2></td>
                </tr>
	            <tr id='tr_title' style='position:relative;z-index:1'>		
                    <td width=750 class='line' id='td_title' style='position:relative;'> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%">
                            <tr> 
                                <td width='5%' class='title'>����</td>
                                <td width='25%' class='title'>�ۼ�����</td>
                                <td width='15%' class='title'>���ð�</td>				  
                                <td width='10%' class='title'>�μ�</td>
                                <td width='15%' class='title'>�ۼ���</td>
								<td width='30%' class='title'>�������</td>
                            </tr>
                        </table>
                    </td>		
    		        <td class='line' width=1550> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%">
                            <tr> 
                                <td width='7%' class='title' rowspan="">��������</td>
                                <td width='7%' class='title' rowspan="">�뵵����</td>				  
            				    <td width='7%' class='title' rowspan="">��������</td>
            				    <td width='14%' class='title' rowspan="">��ü��</td>		
                                <td width='7%' class='title' rowspan="">�����</td>														
                                <td width='8%' class='title' rowspan="">��ȭ��ȣ</td>
                                <td width='5%' class='title' rowspan="">��డ�ɼ�</td>
                                <td width='8%' class='title' rowspan="">��������</td>
                                <td width='6%' class='title' rowspan="">�������</td>
                                <td width='20%' class='title' rowspan="">����� �� �޸�</td>								
                                <td width='5%' class='title' rowspan="">��࿩��</td>
                                <td width='6%' class='title' rowspan="">�Է���</td>
                            </tr>
                        </table>
 		            </td>
	            </tr>
	            <tr>
                    <td width=750 class='line' id='td_con' style='position:relative;'> 
                        <table border="0" cellspacing="1" cellpadding="0" width="100%" >
<%	if(vt_size >0){		
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>  						
                            <tr> 
                                <td width='5%' align='center'><%=i+1%></td>
                                <td width='25%' align='center'><a href="javascript:parent.BranchUpdate('<%=ht.get("TEL_MNG_ID")%>')"><%=AddUtil.ChangeDate3(String.valueOf(ht.get("REG_DT")))%></a></td>
                                <td width='15%' align='center'><%=AddUtil.ChangeTime4(String.valueOf(ht.get("TEL_TIME")))%></td>
                                <td width='10%' align='center'><%=ht.get("BR_NM")%></td>
                                <td width='15%' align='center'><%=ht.get("USER_NM")%></td>
								<td width='30%' align='center'><%=AddUtil.subData(String.valueOf(ht.get("TEL_CAR")), 12)%></td>
                            </tr>
<%}
}else{%>
<tr>
	<td colspan="12" align='center'>�����Ͱ� �����ϴ�.</td>
</tr>														
<%}%>
                        </table>
                    </td>
                    <td class='line'> 
                        <table border="0" cellspacing="1" cellpadding="0" width="1550" >
<%	if(vt_size >0){
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%> 						
                            <tr> 
                                <td width='7%' align='center'><%=ht.get("TEL_CAR_GUBUN")%></td>
                                <td width='7%' align='center'><%=ht.get("TEL_CAR_ST")%></td>
            				    <td width='7%' align='center'><%=ht.get("TEL_CAR_MNG")%></td>
            				    <td width='14%' align='center'><a href="javascript:parent.BranchUpdate('<%=ht.get("TEL_MNG_ID")%>')"><%=AddUtil.subData(String.valueOf(ht.get("TEL_FIRM_NM")), 15)%></a></td>
                                <td width='7%' align='center'><%=AddUtil.subData(String.valueOf(ht.get("TEL_FIRM_MNG")), 7)%></td>
                                <td width='8%' align='center'><%=AddUtil.subData(String.valueOf(ht.get("TEL_FIRM_TEL")), 13)%></td>
                                <td width='5%' align='center'><%=ht.get("TEL_EST_YN")%></td>
                                <td width='8%' align='center'><%=AddUtil.subData(String.valueOf(ht.get("TEL_YP_GUBUN")), 8)%></td>
                                <td width='6%' align='center'><%=AddUtil.subData(String.valueOf(ht.get("TEL_YP_NM")), 6)%></td>
                                <td width='20%' align='center'><%=AddUtil.subData(String.valueOf(ht.get("TEL_NOTE")), 25)%></td>
                                <td width='5%' align='center'><%=ht.get("TEL_ESTY_YN")%></td>
                                <td width='6%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TEL_ESTY_DT")))%></td>
                            </tr>
<%}
}else{%>
<tr>
	<td colspan="12" align='center'>�����Ͱ� �����ϴ�.</td>
</tr>														
<%}%>
                        </table>
		            </td>
	            </tr>
            </table>
        </td>
    </tr>
	<tr>
	<td class='h'></td>
	</tr>
	<tr>
		<td>
		�ص�ϴ�� : ���뿩 �������� �� �繫�Ƿ� �ɷ��� ��ȭ�� ���� ���<br>
		������ : �λ����� �� ��������<br>
		���� ���� �� �Ϻ� �׸� �Է��ص� �˴ϴ�.<br>
		</td>
	</tr>
</table>
</form>
</body>
</html>
