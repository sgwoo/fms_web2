<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.car_register.*, acar.cus_reg.*" %>
<jsp:useBean id="rl_bean" class="acar.common.RentListBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String st 			= request.getParameter("st")==null?"2":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"car_end_dt":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String q_sort_nm 	= request.getParameter("q_sort_nm")==null?"":request.getParameter("q_sort_nm");
	String q_sort 		= request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase cdb = CarRegDatabase.getInstance();
	
	RentListBean rl_r [] = cdb.getRegListAll2(br_id, st,ref_dt1,ref_dt2,gubun,gubun_nm,q_sort_nm,q_sort);  //8
	
	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function pagesetPrint(){
		IEPageSetupX.header='';
		IEPageSetupX.footer='';
		IEPageSetupX.leftMargin=12;
		IEPageSetupX.rightMargin=12;
		IEPageSetupX.topMargin=20;
		IEPageSetupX.bottomMargin=30;	

	}
	
function IE_Print() {
	factory1.printing.header = ""; //��������� �μ�
	factory1.printing.footer = ""; //�������ϴ� �μ�
	factory1.printing.portrait = true; //true-�����μ�, false-�����μ�    
	factory1.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
}

function onprint(){
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
//-->
</script>
</head>
<body leftmargin="15" topmargin="1" onLoad="javascript:onprint()" font face="����">
<!-- <OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/pagesetup/IEPageSetupX.cab#version=1,0,18,0" width=0 height=0>	
	<param name="copyright" value="http://isulnara.com">
</OBJECT> -->
<object id=factory1 style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>
<form action="" name="form1" method="POST" >
  <table width='900' border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="100%" height="30" align="left" style="font-size : 10pt;"><font face="����"># ����������ȣ ������</font></td>
    </tr>
    <tr> 
      <td height="10" align="center"></td>
    </tr>	
    <tr bgcolor="#000000"> 
      <td align='center'> 
	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr  bgcolor="#000000"> 
            <td> 
			  <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr bgcolor="#FFFFFF" align="center">
                  <td width="4%" height="25" style="font-size : 8pt;"><font face="����">����</font></td>
                  <td width="8%" height="25" style="font-size : 8pt;"><font face="����">������ȣ</font></td>
                  <td width="10%" height="25" style="font-size : 8pt;"><font face="����">����ȣ</font></td>          
                  <td width="8%" height="25" style="font-size : 8pt;"><font face="����">������ȣ</font></td>
                  <td width="13%" height="25" style="font-size : 8pt;"><font face="����">����</font></td>                 
                  <td width="7%" height="25" style="font-size : 8pt;"><font face="����">����</font></td>             
                  <td width="8%" height="25" style="font-size : 8pt;"><font face="����">�����</font></td>                                 
	         <td width="8%" height="25" style="font-size : 8pt;"><font face="����">���ɸ�����</font></td>
	         <td width="8%" height="25" style="font-size : 8pt;"><font face="����">�����</font></td>
                </tr>
                        
              </table></td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td height="2" align="center"></td>
    </tr>	
    <tr bgcolor="#000000">
     <td width="100%" height="10" align='center'><table width="100%" border="0" cellspacing="1" cellpadding="0">
        <%if(rl_r.length != 0){ %>
                          <% 	for(int i=0; i<rl_r.length; i++){
                    				rl_bean = rl_r[i];%>		
					
		
          <tr bgcolor="#FFFFFF" align="center">
            <td  width="4%" height="20" style="font-size : 8pt;"><font face="����"><%=i+1%></font></td>
            <td  width="8%" height="20" style="font-size : 8pt;"><font face="����"><%=rl_bean.getCar_doc_no()%></font></td>
             <td  width="10%" height="20" style="font-size : 8pt;"><font face="����"><%=rl_bean.getRent_l_cd()%></font></td>
            <td  width="8%" height="20" style="font-size : 8pt;"><font face="����"><%=rl_bean.getCar_no()%></font></td>            
            <td  width="13%" height="20" style="font-size : 8pt;"><font face="����"><%=rl_bean.getCar_nm()%></font></td>         
            <td  width="7%" height="20" style="font-size : 8pt;"><font face="����"><%=c_db.getNameByIdCode("0032", "", rl_bean.getCar_ext())%></font></td>
            <td  width="8%" height="20" style="font-size : 8pt;"><font face="����"><%= rl_bean.getInit_reg_dt() %></font></td>       
            <td  width="8%" height="20" style="font-size : 8pt;"><font face="����"><%= AddUtil.ChangeDate2(rl_bean.getCar_end_dt()) %></font></td>           
           <td  width="8%" height="20" style="font-size : 8pt;"><font face="����"><%=rl_bean.getBus_nm()%></font></td>            
		
          </tr>
         <%} %>    
		<%} %>
      </table></td>
    </tr>
    <tr> 
      <td height="7" align="center"></td>
    </tr>	
  
  </table>
 
</form>
</body>
</html>
