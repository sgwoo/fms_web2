<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, java.text.*, java.util.*,jxl.*"%>
<%@ page import="acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*, acar.common.*" %>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
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
	
		//�����û����Ʈ
	Vector FineList = FineDocDb.getBankDocAllLists2_C(doc_id ,"B"); //ī�� ���ν�û�� ���� ����Ʈ (����)
	
	int  car_f_amt = 0;   //�츮ī��(0046)�϶��� ���  	
	int  car_dc_amt = 0;   //�츮ī��(0046)�϶��� ���  	
	    
    Date d = new Date();
   	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
   	//System.out.println("���糯¥ : "+ sdf.format(d));
   	String filename = sdf.format(d)+"_���ฮ��Ʈ.xls";
   	filename = java.net.URLEncoder.encode(filename, "UTF-8");
   	response.setContentType("application/octer-stream");
   	response.setHeader("Content-Transper-Encoding", "binary");
   	response.setHeader("Content-Disposition","attachment;filename=\"" + filename + "\"");
   	response.setHeader("Content-Description", "JSP Generated Data");
	
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
	<%if(FineDocBn.getPrint_dt().equals("")){%>
		//print();
	<%}%>
	}
//-->
</script>
</head>
<body leftmargin="15" topmargin="1"  face="����">

<form action="" name="form1" method="POST" >
  <table width='1000' border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="100%" height="30" align="center" style="font-size : 12pt;"><font face="����"><b>�Ƹ���ī ����ī�� �����Һ� ���� ����Ʈ</b> </font></td>
    </tr>
    <tr> 
      <td height="30" align="left">* �߼���: <%=AddUtil.getDate()%></td>
    </tr>	
    
    <tr>
     <td align='center'> 
	    <table width="100%" border="1" cellspacing="1" cellpadding="0">
		    <tr align="center">
		          <td   width="4%" height="25" style="font-size : 10pt;"><font face="����">NO</font></td>
		          <td   width="14%" height="25" style="font-size : 10pt;"><font face="����">������</font></td>
			      <td   width="14%" height="25" style="font-size : 10pt;"><font face="����">����</font></td>
			      <td   width="20%" height="25" style="font-size : 10pt;"><font face="����">�𵨸�</font></td>		
			      <td   width="10%" height="25" style="font-size : 10pt;"><font face="����">����������</font></td>
			      <td   width="14%" height="25" style="font-size : 10pt;"><font face="����">��������(��)</font></td>
			      <td   width="12%" height="25" style="font-size : 10pt;"><font face="����">�Һαݾ�<br>(������������)</font></td>
			      <td   width="12%" height="25" style="font-size : 10pt;"><font face="����">����ī���ȣ</font></td>
			    <!--  <td   width="6%" height="25" style="font-size : 10pt;"><font face="����">������</font></td>	
			      <td   width="4%" height="25" style="font-size : 10pt;"><font face="����">�Ⱓ</font></td>	
			      <td   width="8%" height="25" style="font-size : 10pt;"><font face="����">�����缳���ݾ�(��)</font></td>		-->			   
		   </tr>
        </table>
      </td>
    </tr>    
    <tr>
     <td height="20" align='center'>
     	<table width="100%" border="1" cellspacing="1" cellpadding="0">       
          <% if(FineList.size()>0){
				for(int i=0; i<FineList.size(); i++){ 
					Hashtable ht = (Hashtable)FineList.elementAt(i);	
					
					car_f_amt = AddUtil.parseDigit(String.valueOf(ht.get("CAR_F_AMT")));  //��������   
			 		car_dc_amt = AddUtil.parseDigit(String.valueOf(ht.get("CAR_DC_AMT")));  //dc�ݾ�    
			 	
					
		%>
          <tr  align="center">
            <td  width="4%" height="30" bgcolor="#FFFFFF" style="font-size : 8pt;"><font face="����"><%=i+1%></font></td>
            <td  width="14%" style="font-size : 8pt;"><font face="����"></font><%=c_db.getNameById(String.valueOf(ht.get("CAR_COMP_ID")),"CAR_COM")%></td>      
            <td  width="14%" style="font-size : 8pt;"><font face="����"><%=ht.get("CAR_NM")%></font></td>
            <td  width="20%" style="font-size : 8pt;"><font face="����"><%=ht.get("CAR_NAME")%></font></td>      
            <td  width="8%" style="font-size : 8pt;" align=center><font face="����"><%=String.valueOf(ht.get("UDT_EST_DT")) %></font></td>
            <td  width="14%" style="font-size : 8pt;" align=right><font face="����"><%=AddUtil.parseDecimal(car_f_amt - car_dc_amt)%></font></td>       
            <td  width="12%" style="font-size : 8pt;" align=right><font face="����"><%=AddUtil.parseDecimal(String.valueOf(ht.get("AMT4")))%></font></td>
            <td  width="12%" style="font-size : 8pt;" align=center><font face="����"><%=ht.get("CARDNO")%></font></td>
       
          </tr>
        <% 	} %>
       
		<%} %>
     </table>
     </td>     
    </tr>  
  </table> 
</form>
</body>
</html>
