<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.io.*, acar.cont.*, acar.util.*, acar.common.*, acar.forfeit_mng.*"%>
<%@ page import="java.text.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>

<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String mode = request.getParameter("mode")==null?"0":request.getParameter("mode");
	
	String m_id = "";//��������ȣ
	String l_cd = "";//����ȣ
	String c_id = "";//�ڵ���������ȣ
	String accid_id = "";//��������ȣ
			
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	
	String short_nm= c_db.getNameById(FineDocBn.getGov_id(), "INS_COM");	
	String firm_nm = "";
		
	Vector vt = FineDocDb.getMyAccidDocLists_2(doc_id);
	int vt_size = vt.size();		
	//���� ���μ�
	int tot_size =  vt.size();
				
	int app_doc_h = 0;
	String app_doc_v = "";
			
	int line_h = 32;
	//������ ����
	int page_h = 850;
	//�� ���̺� �⺻ ����
	int table1_h = 315+120;
	int table2_h = tot_size*line_h;	
	int table3_h = app_doc_h+140;
	
	//����������� ���ϱ�
	int page_cnt = ((table1_h+table2_h+table3_h)/page_h);
	if((table1_h+table2_h+table3_h)%page_h != 0) page_cnt = page_cnt + 1;
	
	//������ ���̺� ���� ���ϱ�
	int height = (page_h*page_cnt)-(table1_h+table2_h);	
		
         int t_amt = 0;  
         
         String  req_dt = "";
         
        
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript" type="text/JavaScript">	

	function onprint(){
		factory.printing.header 	= ""; //��������� �μ�
		factory.printing.footer 	= ""; //�������ϴ� �μ�
		factory.printing.portrait 	= true; //true-�����μ�, false-�����μ�    
		factory.printing.leftMargin 	= 10.0; //��������   
		factory.printing.rightMargin 	= 10.0; //��������
		factory.printing.topMargin 	= 10.0; //��ܿ���    
		factory.printing.bottomMargin 	= 10.0; //�ϴܿ���
		factory.printing.Print(true, window);//arg1-��ȭ����ǥ�ÿ���(true or false), arg2-��ü������orƯ��������
	}

</script>
<style>
	*{font-family:dotum;}
	.one{line-height:22pt;}
	.two{line-height:22pt; font-size:11pt;}
	.red{color:black; }
	.red1{color:black;  font-weight:bold;}
	.list{font-size:10pt; text-align:center; font-weight:bold;}
	.line{font-weight:bold; text-decoration:underline;}
	.line1{font-weight:normal; text-decoration:underline;}
</style>
</head>
<body onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
</object>

<form action="" name="form1" method="POST" >
<!--  
<table width='640' height="<%=table1_h%>" border="0" cellpadding="0" cellspacing="0"  align=center>
	<tr>
		<td height=70></td>
	</tr>
	<tr> 
      	<td height="40" align="center" style="font-size : 23pt;"><b>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</b></td>
    </tr>
    <tr> 
      	<td height="60"></td>
    </tr>
    <tr> 
      	<td align=center> 
      		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="one">
          		<tr> 
		            <td width="14%" height="25" valign=top>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��</td>
		            <td width="3%" height="25" valign=top>:</td>
		            <td height="25" width="84%"> �ֽ�ȸ�� �Ƹ���ī <br>��ǥ�̻� �� �� ��</td>
		      	</tr>
		      	<tr>
		      		<td height=20></td>
		      	</tr>
		      	<tr> 
		            <td height="25" valign=top>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��</td>
		            <td height="25" valign=top>:</td>
		            <td height="25"><%=FineDocBn.getGov_nm()%></td>
		      	</tr>
		     	</tr>
        	</table>
        </td>
    </tr>
    <tr>
    	<td height=30></td>
    </tr>
    <tr bgcolor="#000000"> 
      	<td height="2"></td>
    </tr>
    <tr>
    	<td height=60></td>
    </tr>
<% 	
		
           if(vt_size > 0){
			for(int i=0; i<vt.size(); i++){ 
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				if ( i < 1) {
					firm_nm= String.valueOf(ht.get("FIRM_NM"));
				}
				
				
				if(AddUtil.parseInt(String.valueOf(ht.get("AMT5")))==0){
					ht.put("AMT5", String.valueOf(ht.get("AMT3")));						
				}
				
				t_amt +=AddUtil.parseInt(String.valueOf(ht.get("AMT3")));
				
				req_dt = String.valueOf(ht.get("RENT_START_DT"));
			}
			
			//������ û������ + 1	
			req_dt = c_db.addDay(req_dt, 1);
	}				
%>	         
		    
    
    <tr>
    	<td style="font-size:12pt; font-weight:bold;" class="one">������ ���� û���� ��<br> û���ݾ� : �� <%=Util.parseDecimal(t_amt)%> ����</td>
    </tr>
    <tr> 
      	<td height="80" colspan="2" align='center'></td>
    </tr>
    <tr>
    	<td>
    		<table width="50%" border="0" cellspacing="1" cellpadding="7" bgcolor=#000000>
    			<tr>
    				<td bgcolor=#FFFFFF width="45%" align=center height=42>�� ��</td>
    				<td bgcolor=#FFFFFF align=right><%=Util.parseDecimal(t_amt)%>  �� </td>
    			</tr>
    			<tr>
    				<td bgcolor=#FFFFFF align=center height=42>÷���� ������</td>
    				<td bgcolor=#FFFFFF align=right><%=Util.parseDecimal(FineDocBn.getAmt1())%> �� </td>
    			</tr>
    			<tr>
    				<td bgcolor=#FFFFFF align=center height=42>÷���� ������</td>
    				<td bgcolor=#FFFFFF align=right><%=Util.parseDecimal(FineDocBn.getAmt1())%> �� </td>
    			</tr>
    			<tr>
    				<td bgcolor=#FFFFFF align=center height=42>�� �� ��</td>
    				<td bgcolor=#FFFFFF align=right><%=Util.parseDecimal(FineDocBn.getAmt2())%> �� </td>
    			</tr>
    			<tr>
    				<td bgcolor=#FFFFFF align=center height=60>�� ��</td>
    				<td bgcolor=#FFFFFF align=right>�� </td>
    			</tr>
    		</table>
    	</td>
    </tr>
    <tr> 
      	<td height="170"></td>
    </tr>
    <tr align="center"> 
      	<td height="40" style="font-size : 20pt;"><b>�� �� �� �� �� �� �� �� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��  ��</b></td>
    </tr>    
</table>
-->
<p style='page-break-before:always'><br style="height:0; line-height:0"></P>
<table width='640' height="<%=table1_h%>" border="0" cellpadding="0" cellspacing="0" align=center>

	<tr>
		<td height=50></td>
	</tr>
	<tr> 
      	<td height="40" align="center" style="font-size : 23pt;"><b>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��</b></td>
    </tr>
    <tr> 
      	<td height="60"></td>
    </tr>
    <tr> 
      	<td align=center> 
      		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="one">
          		<tr> 
		            <td width="14%" height="25" valign=top>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��</td>
		            <td width="3%" height="25" valign=top>:</td>
		            <td height="25" width="84%"> �ֽ�ȸ�� �Ƹ���ī (115611-0019610)<br>����� �������� �ǻ���� 8, 802ȣ(���ǵ���,�������)<br>��ǥ�̻� �� �� ��</td>
		      	</tr>
		      	<tr>
		      		<td height=20></td>
		      	</tr>
		      	<tr> 
		            <td height="25" valign=top>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��</td>
		            <td height="25" valign=top>:</td>
		            <td height="25"><%=FineDocBn.getGov_nm()%><br><%=FineDocBn.getGov_addr()%><br><%=FineDocBn.getMng_dept()%></td>
		      	</tr>
		     	</tr>
        	</table>
        </td>
    </tr>
    <tr>
    	<td height=30></td>
    </tr>
   <!--  <tr bgcolor="#000000"> 
      	<td height="2"></td>
    </tr> -->
  <!--   <tr>
    	<td height=60></td>
    </tr> -->
      <tr>
    	<td style="font-size:12pt;/*  font-weight:bold; */" class="one">������ ���� û���� ��<br> û���ݾ� : �� <%=Util.parseDecimal(t_amt)%> ����</td>
    </tr>
    <tr> 
      	<td height="100"></td>
    </tr>
    <tr>
    	<td align=center style="font-size : 17pt; font-weight:bold;">-------&nbsp; û&nbsp;&nbsp;&nbsp; ��&nbsp;&nbsp;&nbsp; ��&nbsp;&nbsp;&nbsp; �� &nbsp;-------</td>
    </tr>
    <tr> 
      	<td height="50"></td>
    </tr>
    <tr>
    	<td>
    		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="one">
			    <tr> 
			    	<%
			    	 	SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMdd");
			    		Date date = transFormat.parse(FineDocBn.getEnd_dt());
						
			    		Calendar cal = Calendar.getInstance();
			            cal.setTime(date);
			            cal.add(Calendar.DATE, 1); 
			            transFormat = new SimpleDateFormat("yyyy-MM-dd");

			    	
			    	%>
			    
			      	<td>1. �ǰ�� ������ �� <%=Util.parseDecimal(t_amt)%>�� �� �̿� ���Ͽ� <span class=><%= transFormat.format(cal.getTime())%></span>����  �� ��� ����κ� �۴��ϱ����� �� 5%��, �� ���������� �� ���� �������� �� 12%�� �� ������ ���� �ݿ��� �����϶�.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td>2. �Ҽۺ���� �ǰ� �δ��Ѵ�.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td>3. ��1���� �������� �� �ִ�.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td>��� �ǰ��� ���մϴ�.</td>
			    </tr>
			</table>
		</td>
	</tr>
</table>

<p style='page-break-before:always'><br style="height:0; line-height:0"></P>
<table width='640' height="<%=table1_h%>" border="0" cellpadding="0" cellspacing="0" align=center>
	<tr>
		<td height=20></td>
	</tr>
    <tr>
    	<td align=center style="font-size : 17pt; font-weight:bold;">-------&nbsp; û&nbsp;&nbsp;&nbsp; ��&nbsp;&nbsp;&nbsp; ��&nbsp;&nbsp;&nbsp; �� &nbsp;-------</td>
    </tr>
    <tr> 
      	<td height="50"></td>
    </tr>
    <tr>
    	<td>
    		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="two">
			    <tr> 
			      	<td style="font-weight:bold; font-size:14pt;" colspan="2">��. <span>����ڵ��� ���� �� ����� ����</span></td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="/* font-weight:bold;*/"  colspan="2">1. <span >����ڵ��� ����</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr> 
			      	<td colspan="2">����� �ڵ��� �뿩��, �߰��� �Ÿž�, �ڵ��� ���� �������������� ���� �ֿ� ������� �����ϴ� ȸ���̸�, <span class=red>�ǰ� <%=FineDocBn.getGov_nm()%>(���� ��<%=short_nm%>����� �մϴ�)�� �ڵ�������� ���� �ַ� �����ϴ� ����</span>�Դϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">2. <span >����� ����</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">��. <span >����� �� ��Ʈ �̿���� ���� �ڵ��� �뿩 ����� ü��</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr> 
			      	<td colspan="2">�����, �ҿ� <span class=red> ��<%=firm_nm%>���� <%=vt_size -1 %>�� ��ü</span>�� ���뿩����� �� ü���Ͽ���, ������ �� ��࿡ ���� �Ʒ� ��ü�� �� �ڵ����� �뿩�� �־����ϴ�. �̸� ǥ�� �����ϸ� ������ �����ϴ�.</td>
			    </tr>
			    <tr>
			    	<td colspan="2" style="font-size : 10pt;">&nbsp;[ǥ1]&nbsp; (���� : ��)</td>
			    </tr>
			    <tr>
			    	<td colspan="2">
			    		<table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000 class="list">
			    			<tr bgcolor=#FFFFFF>
			    				<td rowspan="2" width="3%">��<br>��</td>
			    				<td rowspan="2" width="25%">��ȣ</td>
			    				<td rowspan="2">�����</td>
			    				<td colspan="3" height=30>�뿩�̿���Ⱓ</td>
			    				<td rowspan="2">������</td>
			    				<td rowspan="2">���뿩��</td>
			    			</tr>
			    			<tr bgcolor=#FFFFFF>
			    				<td class="list" height=30>������</td>
			    				<td>������</td>
			    				<td>���</td>
			    			</tr>
			    			
 <% 							
            if(vt_size > 0){
				for(int i=0; i<vt.size(); i++){ 
					
					Hashtable ht = (Hashtable)vt.elementAt(i);					
						
					%>					    			
			    	
			    	<tr class=red bgcolor=#FFFFFF>
				            <td height=30><%=i+1%></td>
				            <td><%=ht.get("FIRM_NM")%></td>	
				            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT2")))%></td>
				            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("V_RENT_START_DT")))%></td>
				            <td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("V_RENT_END_DT")))%></td>	
				            <td><%=ht.get("CON_MON")%>����</td>	
				            <td align='right'><%=Util.parseDecimal(ht.get("GRT_AMT"))%>&nbsp;</td> 
				            <td align='right'><%=Util.parseDecimal(ht.get("FEE_AMT"))%>&nbsp;</td>					    
				 </tr>
		      <% 	}
	} %>
 		</table>
			    	</td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr> 
			      	<td colspan="2">���� �� �� �ڵ��� �뿩 �̿� ��༭������ ������������ �� ���������񽺰� �Ϻ� ���ԵǾ� ������, <span >���� �̿���� ���ػ�� ���Ͽ��� ��쿡�� ���������񽺸� �������� �ʴ� ������ ��õǾ� �־����ϴ�.</span> Ư��, �� ��� �� �ڵ����뿩��࿡�� �� ��� ��Ʈ�̿������ �������� ���ػ���� ��쿡 ���� ����������[����]�� �������� �ʴ� ������ ������ ���Ƿ� ���ߵ� ����� ��� �� ���� ���� ���ش� ������ ������(�Ǵ� �����ڰ� ������ ����ȸ��)�� �ڽ��� ���� å������ �� ����� ����ϴ� ���� �翬�� �Ӹ� �ƴ϶� ����ī �̿���� �ƹ��� ������ ���� ������ ��Ʈȸ���� ���� ���ظ� �����ϸ鼭���� ����ī �̿������ �� ���������񽺸� �� �� ��� ������ ���� �����Դϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td colspan="2" style="font-weight:bold;">��. <span >���� ���Ƿ� ���� �ڵ��� �浹����� �߻�</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr> 
			      	<td colspan="2">�׷��� ����κ��� �� �ڵ����� �뿩���� �� ��� ��Ʈ �̿������ �� ��� �� �ڵ��� ���뿩 ��࿡ ���� �� �� �ڵ����� �̿��ϴ� ��, ������ 100% �Ǵ� �ֹ� ���Ƿ� ���ߵ� �ڵ��� �浹��� �� �߻��Ͽ���, �ᱹ �� ��� ��Ʈ �̿������ ��Ʈ�� �ڵ����� ����� �Ⱓ ���� �̿����� ���Ͽ� �ٸ� ������ �����Ͽ��� �ϴ� ���ظ� �԰� �Ǿ����ϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">����, �� �� ������� �����ڵ��� ��� <%=short_nm%>�� �����ϰ� �־��� ��, �� ���� ��� ǥ�� �����ϸ� ������ �����ϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr>
			    	<td style="font-size : 10pt;">&nbsp;[ǥ2]</td>
			    	<td style="font-size : 10pt;" align=right>&nbsp;</td>
			    </tr>	   				
			
			   <tr>
			    	<td colspan="2">
			    		<table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000 class="list">
			    			<tr bgcolor=#FFFFFF>
			    				<td width="5%">����</td>
			    				<td width="20%">������</td>
			    				<td width="10%">����������ȣ</td>
			    				<td width="15%"height=30>���߻���</td>
								<!-- <td width="50%"height=30>������</td> -->
			    			</tr>

 <% 							
            if(vt_size > 0){
				for(int i=0; i<vt.size(); i++){ 
					
					Hashtable ht = (Hashtable)vt.elementAt(i);					
			
					%>					    			
			    	
					    	<tr class=red bgcolor=#FFFFFF>
								<td height=30><%=i+1%></td>
								<td><%=ht.get("FIRM_NM")%></td>	
								<td><%=ht.get("OUR_CAR_NO")%></td>	
								<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ACCID_DT")))%></td>
								<%-- <td><%=ht.get("ACCID_CONT2")%></td> --%>
						    			    
						 </tr>
		      <% 	}
	} %>
			    		</table>
			    	</td>
			    </tr>
			    
			     <tr>
			    	<td colspan="2">  1) ���� ���� ȸ��� �� �� �����ڵ��� ���������� �ľ����� ���Ͽ� �� �� �����ڵ��� Ư���ϱ�� ����� ��Ȳ�Դϴ�.</td>
			    </tr>
			     <tr>
			    	<td height=25></td>
			    </tr>
			    <tr>
			    	<td colspan="2" style="font-weight:bold;">��. <span >������ �ǰ� ���� ������ ����� ����� û��</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�̿� �������� �� ��� ��Ʈ �̿������ ���� ȸ�翡�Դ� ������(��� �� ������ ������ �޴� ���� �� ������ ��ü�� ���ο� ������ ��Ʈ)�� ��û�Ͽ��� ����� �� ��� ��Ʈ�̿������ ��������� ���� �Ǵ� ������ ������ �������� ����(�ܱⷻƮ)�����Ͽ����ϴ�.<span >[������������ ���� ����]</span></td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2"> ���� ����� �������� ������� �ǰ���, �������� �� ��� ��Ʈ �̿���� �����Ͽ� �޺��� ���Ǹ� ���Ͽ� <span >��� �����ῡ �ش��ϴ� ���رݾ׿� ���Ͽ� ������� ������ ��û</span>�Ͽ����ϴ�[�ٽ� ���ؼ�, �̴� ��Ģ������ �� ��Ʈī �̿������ �� �ǰ� ���� û���Ͽ� �� ������� ������ �� �ٽ� ������ �� �����Ḧ �����Ͽ��� �ϴ� ���� ��Ģ�̳�, 
			    	������� ����� û���� ���������� �޺��� ���Ǹ� ���Ͽ� ���� �̸� �ϰ��Ͽ� û���� ���Դϴ�]. �׷��� �ǰ�� ������ <span >���� û���ϴ� �����ῡ ����ϴ� �ݾ��� �ƴ� �����ῡ ����ϴ� �ݾ׸��� �����ϰ� �ִ� ��,</span> �� û���ݾ�, û������, �������� ���� �Ʒ� ǥ�� �����ϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    
		       <tr>
			    	<td style="font-size : 10pt;">&nbsp;[ǥ3]</td>
			    </tr>
			      <tr>
			    	<td style="font-size : 10pt;" align=left>&nbsp;(���� : ��)&nbsp;</td>
			    </tr>
			    <tr>
			    	<td colspan="2">
			    		<table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000 class="list">
			    			<tr bgcolor=#FFFFFF>
			    				<td width="4%">��<br>��</td>
			    				<td width="25%">��������</td>
			    				<td>����<br>����</td>
			    				<td height=40>���Ǻ���<br>(������)</td>
			    				<td>û��<br>����</td>
			    				<td>û����</td>
			    				<td>�Ա�<br>����</td>
			    				<td>�Աݾ�</td>
			    				<td>����</td>
			    			</tr>

 <% 							
            if(vt_size > 0){
				for(int i=0; i<vt.size(); i++){ 
					
					Hashtable ht = (Hashtable)vt.elementAt(i);					
					
					if(AddUtil.parseInt(String.valueOf(ht.get("AMT5")))==0){
						ht.put("AMT5", String.valueOf(ht.get("AMT3")));						
					}
																	
					%>					    			
			    	
					    	<tr class=red bgcolor=#FFFFFF>
								<td height=30><%=i+1%></td>
								<td><%=ht.get("OUR_CAR_NO")%><br><%=ht.get("FIRM_NM")%></td>	
								<td><%=ht.get("CAR_NO")%></td>	
								<td><%=ht.get("OT_FAULT_PER")%>%</td>						    	
								<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>		
								<td align='right'><%=Util.parseDecimal(ht.get("AMT1"))%></td>    
								<td><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
								<td align='right'><%=Util.parseDecimal(ht.get("AMT2"))%></td>
								<td align='right'><%=Util.parseDecimal(ht.get("AMT3"))%></td>
							</tr>
		      <% 	}
	} %>		
			    		</table>
			    	</td>
			    </tr>
			    
			      <tr>
			    	<td height=25></td>
			    </tr>
			    <tr>
			    	<td colspan="2" style="font-weight:bold;">��. <span >�ǰ��� ������ ������</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�̿� ����� �ǰ��� ���޹��� ���� ���׺��� �ޱ� ���Ͽ� �߰��� �޾ƾ��� �ݾ׿� ���Ͽ� ������ ���� �ְ��Ͽ����ϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�׷��� �ǰ�� ����� �߰� ������ �����Ͽ��� ��, �ᱹ ����� �̷��� ���׺п� ���� ������ ���� ���� ���ϰ� �ִ� ��Ȳ�Դϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=50></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold; font-size:14pt;" colspan="2">��. <span >������ �ǰ� ���� û�� ����</span></td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">1. <span >�� ��� ������ ��� �߻��� �����ڵ��� ������ ���� �� ����</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�����ڵ��� �� ��� ���� ���Ͽ� �ڽ��� ��ⷻƮ�� �������� ������� ���ϰ� ������ ���Ͽ� <span >���� �Ǵ� ������ ���ο� ������ �ٽ� �ܱⰣ ����(�� ��ⷻƮ ������ �����Ⱓ ����) ��Ʈ�Ͽ��� �ϹǷ� �� �ܱⷻƮ��� ����� ���ذ� �߻�</span>�Ͽ��ٰ� �� ���Դϴ�. 
			    	�ٽ� ���ؼ�, �� �� ���� ���� �����ڴ� �������� <span >����ī �̿������ ����ī ȸ���� ���� �ƴϸ�,</span> ������ ���� �ǰ� ����Ͽ��� �� ������ ���� ���� <span >����ī �̿���� �� ���� ���Ͽ� ��Ʈ�� ������ �̿����� �������ν� �ٸ� ������ �ܱ�뿩�ϱ� ���Ͽ� �����Ͽ��� �ϴ� �ݾ�</span>�Դϴ�. 
			    	�ᱹ �Ǻ�����(�ǰ� �����)�� �����ڿ��� ����ؾ� �� �ݾ��� �����ڵ��� ������ �����ϴ� �Ⱓ ���� �ٸ� ������ �뿩�ϴ� �������� �����Ͽ��� �ϴ� �ܱⷻƮ����� �� ���̹Ƿ�, �̴� �����ڰ� �����ڿ��� �����ῡ ����ϴ� �ݾ��� �����ؾ� ���� �ǹ��մϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">2. <span >�ǰ� <span class=red><%=short_nm%></span>�� ������ �ݾ� ������ �ٰ�</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�̿� ����� �޺��� ���ǻ� �����ڸ� ����Ͽ� �ǰ� ����翡�� �� �����ῡ ����ϴ� ����Ḧ û���Ͽ��¹�, �ǰ�� ���� û���� �ݾ׿� �ξ� ��ġ�� ���ϴ� �ݾ׸��� �����Ͽ����ϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�׷��� �ǰ� ������ �ݾ��� ���� û���� �ݾװ� ���̰� ���� ������, ���� �����ῡ ����ϴ� �ݾ��� û���Ͽ��µ� ���Ͽ� �ǰ�� �����ῡ �ش��ϴ� ���رݾ׸��� �����Ͽ��� ������ ������ �ľǵ˴ϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�׷��� �ǰ� ��ó�� ������ �����Ḹ�� �����ϴ� ���� �δ��� ��, �̿� ���Ͽ��� �Ʒ����� ���� �޸��Ͽ� �ڼ��� �����ϵ��� �ϰڽ��ϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">3. <span >�ǰ��� ����� ���ޱݾ� ������ �δ缺</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">��. <span >�ڵ����������� �빰����� ���ޱ������μ� ������� �����ῡ ���� ����</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			     <tr>
			    	<td colspan="2">����ȸ��� ���߻��� �������� ���� �빰����� �ϰ� �Ǵµ� �� ������ <span >�Ǻ������� ���ع��ä���� �μ��Ͽ� �̸� ���</span>�ϴ� ���Դϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">���� �빰����� ����� ���ޱ��ؿ� ���Ͽ� ������� �����ῡ ���� ������ �ִµ�, �������ᡱ�� <span >������ �ڵ���</span>�� �ļ� �Ǵ� ���յǾ� �������� ���ϴ� �Ⱓ ���ȿ��� �ٸ� �ڵ����� ��� ����� �ʿ䰡 �ִ� ��� 
			    	�׿� �ҿ�Ǵ� �ʿ� Ÿ���� ����̶�� ���ǵǰ� �ְ�, �������ᡱ�� <span >����� �ڵ���</span>�� �ļ� �Ǵ� ���յǾ� ������� ���ϴ� �Ⱓ ���ȿ� �߻��ϴ� Ÿ���� �������ض�� �����Ǿ� �ֽ��ϴ�.</span> </td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">���� �ǰ���� �� ����Ḧ �����Կ� �־� <span >�� ��� ����������� ������ ������ ���� ������ �Ͽ�</span> �� ��� ����������� ������ �ڵ����� ���� ������ �����Ḹ�� ������ ������ ���Դϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�׷��� �� ������� �������� ���б����� �Ǵ� ���� <span >�ش� ������ ������ �ڵ������� �ƴϸ� ����� �ڵ������� ������ ��</span>���� ���� ���̴µ�, �̴� �ܼ��� �ش� ������ ��� ���ǰ� ������ �������� �ƴϸ� �񿵾��� 
			    	���������� ���� �������� ���ؿ� ���� �Ϸ������� ���еǴ� ���� �ƴ϶� <span >��������� �ش� ������ ���� ������ ���� �����Ǵ� ����</span>�Դϴ�. </td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�ٽ� ���ؼ� ����� �ڵ����� ��� <span >�ش� �ڵ����� ���� ���� ��ü�� ������ �����Ͽ� ���� ���Ͽ� ����Ǵ� �����μ� �ش� ������ ���� �� ��ü�� ������ ���� ��츦 �ǹ�[���� ��� �ý�, ���� ��]</span>�ϴ� �� ���Ͽ� ������ 
			    	�ڵ����� ��� �ڵ����� ���� ���� ��ü�� ������ �����Ͽ� ���� ���� �ƴ� ���� ���մϴ�. ���� ��� ����� �����ϴ� �Ϲ� ȸ�翡�� ������ ���Ͽ� ����ϰ��� ������ ���� ������ ��쿡�� �̴� ����� ������ �ƴ� ������ ������ �ش��ϴ¹�, �� ������ �� ������ 
			    	�����ϴ� ���� ��ü�� ���� �� ��ü�� �Ǵ� ���� �ƴϱ� �����Դϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">���� ���� ���� ������� ������ ���� �� ���ؾ��� ������ ���̰� ���� ������ ������ ������ ��� �ش� ��� ������ ���� ���� ��ü�� ������ �����Ͽ� ���� ���� ���̱� ������ <span >�����ڰ� �� ������ �̿����� �������ν� �߻��ϴ� 
			    	���ش� ���������ء��μ�, �ᱹ �� �������ذ� ���Ǽ��ء��� �ش��Ѵٴ� ��</span>�� �ٰ��ϴ� ���Դϴ�. �׷��� ����� ������ �ƴ� ������ ������ ��쿡�� �ش� �Ⱓ���� �� ������ �̿����� �������ν� �ٸ� ������ �̿��ϴµ� �ҿ�Ǵ� ����� �Ǽ��ذ� �ǰ�, �̴� 
			    	�ᱹ �����ῡ �̸��� �ݾ��� ���Ǽ��ء��� �ش��ϹǷ� ����ȸ��� �� ��� �Ǽ��ظ� ����Ͽ��� �ϴ� ���Դϴ�. </td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�׷��Ƿ� �� ��� ��� ���� ����� ������ �־�, �ǰ� �����Ͽ��� �ϴ� ������� �����ϱ� ���ؼ��� �� �� ���� ���� �����ڴ� ��������, �� �Ǽ����� ������ �����, ��Ʈ�� ������ ������ �������� ���ƾ� �ϴ��� ������ �������� ���ƾ� 
			    	�ϴ����� �� ����� �ֿ� ������ �� ���Դϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">��. <span >�� ��� ����� ������ �� ������ ����� �� ��� ����</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">(1) ������</td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>	
			    <tr>
			    	<td colspan="2">�ǰ�� �� ��� ��������� ������ ��Ʈ���� �����ϴ� ������ �����ӿ� �����Ͽ�, �� ��������� ���� �빰���ش� �������ᡱ���� �����ϸ� �װ����� ���� ������ �Ǵ��ϰ� �ֽ��ϴ�. �׷��� �ǰ�� ���� �����ڿ� ������ ������ �����Ͽ� �� �����ٰŸ� 
			    	�׸�ġ�� �ִ� ��, �ռ� ������ �ٿ� ���� �� ���� ���Ͽ� ���� �����ڸ� ����Ͽ� �ǰ��� û���ϰ� �ִ� ���ش� �� ���� ���Ͽ� �ش� ������ �̿����� �������ν� �߻��� ���طμ� �� �����ڴ� �� ����ī �̿���̸�, �� ����ī �̿���� ���ش� <span >���ο� 
			    	������ ���������ν� �߻��ϴ� �����ῡ ����ϴ� �ݾ�</span>�ӿ��� �ǰ�� �� ��� ����� �����ڰ� ��ġ ������ ��ó�� �����ϰ� �ֽ��ϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�ٽ� ���ؼ� �ǰ��� ����� ���� �ٰŴ�, �� ��� ������ ������ �����̹Ƿ� �� ��� ���� ���� ���������� ������ ���� ����ī ȸ���� ����� ���ƾ� �Ѵٴ� �������� ������ ��Ե� ������ ���̳�, <span >�� ���� ���� ���������� �����ڴ� ���� ����ī�� 
			    	�̿��ϰ� �ִ� �̿��</span>���� ���ƾ� �ϹǷ� �ǰ�� �޺��� ���ǻ� �̿���� ����Ͽ� ������� û���ϴ� ������ ������ ������ ����Ḧ ����Ͽ��� �մϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�̷��� ������ �޹�ħ�� �� �ִ� �ٰſ� ���ؼ��� �Ʒ����� ���� �޸��Ͽ� �����ϱ�� �ϰڽ��ϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">(2) ��ⷻƮ�� Ư¡</td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�� �����, ����ī �̿���� ���� ���� �ش� ������ ���ؼ� ��� �ڵ����뿩����� ü��� ������� �ռ� ���캻 �ٿ� �����ϴ�. �׷��� �� ��� ����ī �̿���� ���忡���� �� �ش� ��� �Ⱓ ���� ���� ������ �������� �� ������� ���������� �ο� �ް� �ǰ�,
			    	 �� ������ ���忡���� �ش� ����ο��� �ҹ��ϰ� <span >�ش� ������ ���Ͽ� �ſ� ��Ʈ�� ���������� ����</span> �ް� �ǹǷ�, ���� ���忡���� �ش� ������ ���ؼ� ������ ���������ء���� ���� �߻��� �� �����ϴ�. �ٽ� ���� ����ī ȸ���� ���� �̿�����κ��� 
			    	 �ſ� ���޹ް� �ִ� ��Ʈ��� �̹� ������ ������ �ش� ������ ���� ��������̱� �����Դϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">���ư� �� ��Ȱ� ���� �̿���� ����ī ȸ�� ���� ��ⷻƮ����� ü��� ��쿡�� <span >�� ���ü��Ⱓ ������ ��� ������ ���� ��� �������� ��������� ����ī �̿���� ����</span>�ϰ� ������, ����ī �̿���� <span >�ش� ������ �ڽ��� �ڰ������� ���</span>�ϰ� �˴ϴ�. 
			    	���� ��ⷻƮ�� ��� �̿���� �ش� ���Ⱓ ���� �̸� �ڽ��� �����Ͽ� ������ ������ �뵵�� ����ϴ� ���̹Ƿ� �� ������ ���Ⱓ ���� ��ġ �ڽ��� �ڰ������� ����ϰ� �ִ� ���� ���忡���� �ش� �뿩������ ����� �ڵ������ �� �� �����ϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">���� �̷��� ��Ȳ���� ������ ��ⷻƮ�� �� ��� �̿������ �ش� ������ ���Ͽ� ��� ���� ���, ����ī �̿���� �ش� ������ �Ͻ������� ������� ���ϰ� ���ο� ������ �����ϱ� ���Ͽ� ������ ����� �����Ͽ��� �����ν� �߻��ϴ� ���ش�
			    	 ������ī �̿�������� �߻��� �������� ����ī ȸ�翡�� �߻��� ���ض�� �� �� �����ϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�ٽ� ���ؼ� �ش� ������ <span >������� �ڵ��������� ����</span>�� <span >���� ����ī ȸ����� ���迡���� ����</span>�� �� ���� ��, �� ��� �� ���� ���� �� ��� �̿���� �ڵ������뿩����� ���Ͽ� ���뿩���� �ڵ����� <span >�������� �������� �����ϴ� �������� 
			    	�߻��� ����� ���</span> �ñ������δ� �Ͻ������� ���ο� ���� �����Ͽ��� �ϴ� ���������� �����ڴ� �� ��� �̿� ���� �̻�, �̹� ������ �뿩�Ǿ� ���� �̿��ϰ� �ִ� �ش� ������ ���̿���� �����ڿ��� ���衱������ ������ �ڵ����� �Ұ��� ���̹Ƿ�, �ǰ�� 
			    	�̿���� ���ο� ���� �����Ͽ��� �����ν� ��� ����� ������ ������ �����Ͽ��� �ϴ� ���Դϴ�[�ٸ� �޺��� ���ǻ� ����ī ȸ�簡 �̸� û���ϴ� �Ϳ� �Ұ��մϴ�].</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�Ӹ� �ƴ϶� ����� ���ޱ��ؿ� �־ �����ῡ �����ϴ� ���ظ� ����ϵ��� �Ǿ� �ִ� �������� �������� ���Ρ��� ���� ������ �ڵ��� ����� ���� ���б��ؿ� ���� ���������� ����ȴٰ� �� �� ���� ��, �̿� ���� ���ɻ� ��Ȯ�� ������ ���� ���õǾ� ���� �ʽ��ϴ�. 
			    	</td>
			    </tr>
			     <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">���� ������ ������ ��� �����ῡ ����ϴ� 
			    	���ظ� ����ϵ��� �� ������ �ش� ���� ���ش� ���������ء��� �Ұ��ϱ� �����̳�, �ռ� ������ �ٿ� ���� ���뿩�� ��� �� �������ظ� ���� �����ڴ� �������� ����ī �̿�����μ� ���������ء��� �ƴ� ���������ء��� �� �Ǽ����̹Ƿ� �ش� ������ �ڵ��� ����� �� ����� �������� ���еǾ� �ִٴ� ���������� ��� ��쿡�� 
			    	�ݵ�� �ش� ������ ���ؼ��� �������ظ� ���޹޾ƾ� �Ѵٰ� ���������� ������ ���� ���� �����Դϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">���� ��� �߻��� ��� ����ī �̿���� ��Ʈ�Ⱓ �� �ش� ���� ���Ͽ� ������ ��Ʈ�� ������ �̿����� ���ϰ� �Ǿ� ������ ����� �鿩 ���ο� ���� �����Ͽ��� �ϴ� ���̹Ƿ� �������ؿ� ���� �����ڴ� ��� ���� �� ��� ��Ʈī �̿������ ���ƾ� �Ѵٴ� ������� �Ͱ�� �� �ֽ��ϴ�. 
			    	</td>
			    </tr>
			     <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�׷��Ƿ� �̿� ���� ������ �Ǵ� �������� ����ȸ��� �̿���� �̷� ���Ͽ� ���ο� ������ ���� �ϴµ� �ҿ�Ǵ� ����� ������ ������ �����Ͽ��� �ϹǷ�, �̸� �̿���� ����Ͽ� ���� �ǰ��� û���ϴ� �̻�, �ǰ�� �̸� ���� ������ �ǹ��� �ִ� ���Դϴ�.</td>
			    </tr>
			   
			   <!-- 
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">(3) ���ݰ�꼭�� ���� ����</td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">���ư� �ڵ������뿩�� ��� ���� ����� ����ī ȸ�簡 �̿������ ���ο� ���� �����ϴ� ��쿡 �־ ����ī ȸ��� <span >�ܱ� ��Ʈ����� �����Ḧ �����Ͽ� �����Ƿ� ���ݰ�꼭�� ����</span>�ϰ� �ֽ��ϴ�. �̸� ������ ���������� �����ڴ� ���������� ����ī �̿���̶�� ���� ��Ȯ�ϰ� ����˴ϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�ٽ� ���ؼ� �̿���� ��Ģ������ �ܱⷻƮ�� �����ϴ� �����̿�Ḧ ����ī ȸ�翡�� �����Ͽ��� �ϰ� ���Ŀ� �̸� ������ �� ����ȸ��κ��� ���� ���� �� �ִ� ���� ��Ģ�̳�, �̸� <span >�޺��� ���ǻ� ����īȸ���� ���� ����ȸ���� �ǰ��� ���� �� ������ û���ϴ� �Ϳ� �Ұ��մϴ�.</span></td>
			    </tr>
			      -->
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">Ư�� �ռ� ������ �ٿ� ����, �� ��� �� ���뿩��༭������ ����ī�̿���� ���� ���Ƿ� ���Ͽ� �߻��� ���� ���Ͽ�, �ش� ������ �̿����� ���ϴ� ��� �̴� ������ ������ ���� ����� å���� �ִ� ���� ��Ģ�̹Ƿ� ����� �ٸ� ������ �������� �����ϴ� ���񽺸� �������� �ʰ� �ֽ��ϴ�. 
			    	���� �� ��� �������� ����ī �̿���� ����κ��� ������ �ޱ� ���ؼ��� �̸� �������� �ܱ�뿩�� ������ �Ͽ��� �ϴ� ���Դϴ�. <!-- ������ �Ͽ��� �ϴ¹�, �̿� ����� �� ��� ����ī �̿������ ���ݰ�꼭�� �����Ͽ��� ���Դϴ�(��Ģ������ �� ��� ����ī�̿���� ������ ���� �� �ܱ�뿩�� ����ϴ� �ݾױ��� �������طμ� û���� �� 
			    	�����Ƿ� �� ����� ���� �ǰ��� ��ٷ� ���� û���� ������ �ռ� ����帰 �ٿ� �����ϴ�).--></td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">(3) �ٸ� ����ī ȸ��κ��� ���� ������ ������ �� ����</td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">���� ���� �����, �ǰ�� ���� <span >����ī �̿� ���� ������ ��ⷻƮ����� ü���Ͽ��� ��ü�� ���� �ƴ� �ٸ� ����īȸ��κ��� ���ο� ���� ������ ���, �ٸ� ����īȸ�翡�Դ� �������� ���ס��� ����</span>�ϰ� �ֽ��ϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�̸� ������, ��ⷻƮ ����� ü���� �̿���� ��� ���� ��� �ش� �̿������� �Ͻ������� ������� �������ν� ���ο� ������ �Ͻ������� ����Կ� ���� �߻��ϰ� �Ǵ� ������ ��ü�� ������ī �̿�����̶�� ���� ��Ȯ�� ����� �� ������, �� ������ ������ ������ �����̶�� ��� ���� ���Ҿ� ����˴ϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�Ӹ� �ƴ϶� �� ��� ����ī �̿���� ��ⷻƮ����� ü���� ��ü�� �ƴ� �ٸ� ����ī ��ü�κ��� ���ο� ���� �Ͻ������� �����Ͽ��ٴ� ���� �޶��� ��, ��� ������ ������ ��Ȳ[������ ���� ����ī ȸ����� ���� �����谡 �����ǰ� �ִ� �̻� ���� ���� �̿����� ���ϴ��� �� �뿩�Ḧ ���� �����谡 �ִ� 
			    	����ī ��ü���� ��� �����Ͽ��� �ϱ� ������ �ٸ� ������ ������]���� <span >�̿� ���� ���� ������ ������ �����ñ��� ��� ����ī ��ü�κ��� ���ο� ���� �Ͻ������� ������ �������� ���� �쿬�� ������ ���� �� ��������� �޶����ٴ� ���ε�</span> �̷��� ������ ���ո��� �Ӹ� �ƴ϶� �̸� �޸� �����Ͽ��� �� �ո����� ������ �����ϴ�.</td>
			    </tr>
			    
			        <tr>
			    	<td height=25></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2">��. <span >�Ұ�</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr>
			    	<td colspan="2">���� <b>��</b>�ٸ� ����ī��ü�� ���� ���� �������� ���� �߻��� ������ �������� �����κ��� ������ ������ ���޹��� �� �ִ� ���� ���߾ �� ��ⷻ��ī �̿���� ���ο� ���� �����Ͽ��� �����μ� �߻��Ǵ� ������ �������ش� <span >�̿� ������ �߻��Ǵ� ��</span>�̹Ƿ� <span >�������� �����ڴ� ����ī �̿��</span>�̰�, �̸� ����ī ��ü�� �޺��� ���ǻ� 
			    	���� û���ϴ� �Ϳ� �Ұ��ϴٴ� ��, <b>��</b>���� �̿���� �ٸ� ����īȸ��κ��� �Ͻ������� ������ �����ϴ� ��Ȳ�� �����ϴ���, <span >����ī �̿�����μ��� ���뿩�Ḧ ���� ȸ�翡�� ������ �����Ͽ��� �Ѵ�</span>�� ���� ���߾ �� ����ī �̿���� �����ϴ� <span >�� �뿩��(������ ���׿� �Ұ�)�� ������ �뿩�� ������ ���� �������� �޺ο� �Ұ�</span>�ϴٴ� ��, 
			    	<!-- <b>��</b>�̿���� �ٸ� ����ī ��ü�κ��� �����ϴ� ��� �ٸ� ����ī ��ü ���� <span >�� ���Ƿ� ���ݰ�꼭�� ����</span>�ϰ� �̸� �ٸ� ����ī��ü�� ����ȸ�翡 ���� û���Ѵٴ� ��, --> <b>��</b>���� ���� ���� �ݾ��� ������ �����̹Ƿ� , <span >��ⷻƮ�� ��� ���ο� ���� ���������ν� �߻��ϴ� ������ ������ ������ ����� ���ؾ��̶�� ��</span>�� ���������� Ȯ�ΰ����ϴٴ� 
			    	�� � ���߾� ������ �� ����� ��� <span >�������� �����ڴ� ����ī �̿��</span>�̱� ������ ���������� �������� ���Ƿ� ��� �߻��Ͽ� ����ī �̿���� ���ο� ���� �����ϴ� ��� �ǰ� ������ ������ ���׸� �����ϴ� ���� �δ��ϴٰ� �� ���Դϴ�. </td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">���Ͽ����� �� �������� ������ �����ؾ� �� ��ü���� ������� �ݾ׿� ���Ͽ� �����ϰڽ��ϴ�.</td>
			    </tr>
			    
			        <tr>
			    	<td height=50></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold; font-size:14pt;" colspan="2">��. <span >������ �ǰ� ���� �� ����� û���ݾ��� ��ü���� ��������</span></td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    
 		 <% 							
            if(vt_size > 0){
				for(int i=0; i<vt.size(); i++){ 
					
					Hashtable ht = (Hashtable)vt.elementAt(i);					
					
					if(AddUtil.parseInt(String.valueOf(ht.get("AMT5")))==0){
						ht.put("AMT5", String.valueOf(ht.get("AMT3")));						
					}
					
					String i_start_dt = String.valueOf(ht.get("USE_ST"));				   
					String i_end_dt = String.valueOf(ht.get("USE_ET"));
			   
			%>						    
			 <!--     
			    <tr> 
			      	<td style="font-weight:bold;" colspan="2"><%=i+1%>. <span >������ <span class=red><%=ht.get("FIRM_NM")%> (<%=ht.get("OUR_CAR_NO")%>)</span> ���� �����û���ݾ�</span></td>
			    </tr>
			    <tr>
			    	<td height=15></td>
			    </tr>
			    <tr> 
			      	<td colspan="2">
						<tr>
							<td>
								<table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000 >
									<tr bgcolor=#FFFFFF>
										<td width="20%" align="center" style="font-size : 10pt;">��ȣ</td>
										<td width="10%" align="center" style="font-size : 10pt;">��������</td>
										<td width="10%" align="center" style="font-size : 10pt;">��������<br>(<%=ht.get("CAR_NO")%>)</td>
										<td width="20%" align="center" style="font-size : 10pt;">�����Ⱓ</td>
										<td width="10%" align="center" style="font-size : 10pt;">������</td>
										<td width="30%" align="center" style="font-size : 10pt;">������</td>
									</tr>
									<tr bgcolor=#FFFFFF>
										<td align="center" style="font-size : 10pt;"><%=ht.get("FIRM_NM")%></td>
										<td align="center" style="font-size : 10pt;"><%=ht.get("OUR_CAR_NM")%></td>
										<td align="center" style="font-size : 10pt;"><%=ht.get("CAR_NM")%></td>
										<td align="center" style="font-size : 10pt;"><%=AddUtil.ChangeDate2(i_start_dt)%> ~ <br><%=AddUtil.ChangeDate2(i_end_dt)%><br><%=ht.get("USE_DAY")%>��&nbsp;<%=ht.get("USE_HOUR")%>�ð�</td>
										<td align="center" style="font-size : 10pt;"></td>
										<td align="center" style="font-size : 10pt;"><%=Util.parseDecimal(ht.get("AMT1"))%> =((<%=Util.parseDecimal(ht.get("DAY_AMT"))%>��(��)*<%=ht.get("USE_DAY")%>��)+(<%=Util.parseDecimal(ht.get("DAY_AMT"))%>��(��)/24*<%=ht.get("USE_HOUR")%>�ð�))</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td>
								����� <%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%> �ǰ� ����ȸ�翡�� <%=Util.parseDecimal(ht.get("AMT1"))%>���� û���Ͽ����� 
								�ǰ�� ������ <% if(AddUtil.parseInt(String.valueOf(ht.get("AMT2")))==0){%>�Ա��� ���� �ʰ� �ֽ��ϴ�.<%} else {%><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%>�� ����<%=Util.parseDecimal(ht.get("AMT2"))%>������ �����Ͽ����ϴ�.<%} %>
							</td>   			    
						</tr>
					</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">���� ����� ������ <%=ht.get("FIRM_NM")%>���� <% if(AddUtil.parseInt(String.valueOf(ht.get("AMT2")))==0){%> ������ <%=Util.parseDecimal(ht.get("AMT3"))%>��<% }  else {%> ������� �������� ������ <%=Util.parseDecimal(ht.get("AMT3"))%>��(<%=Util.parseDecimal(ht.get("AMT1"))%>��-<%=Util.parseDecimal(ht.get("AMT2"))%>��)<%}%>�� ���޹��� ä���� ������ ������ �ְ�, ������ <%=ht.get("FIRM_NM")%>�� �������� ��������  �ǰ��� ���� �ݾ��� �����û������ ������ �ֱ� ������ ����� ������ <%=ht.get("FIRM_NM")%>�� 
			    	�����Ͽ� �� �����û������ ����Ͽ����Ƿ� �ǰ�� ������ <%=Util.parseDecimal(ht.get("AMT3"))%>�� �� ������ û���� �������� <span class=red1><%=AddUtil.ChangeDate2( c_db.addDay(String.valueOf(ht.get("RENT_START_DT")) , 1)  ) %></span>���� �� ��� ����κ� �۴��ϱ����� �ι��� ���� �� 5%��, �� ���������� �� ���� ��������<% if ( i < 1  )  {%> �Ҽ����� � ���� Ư�ʹ�(���� ��<b>�Ҽ�������Ư�ʹ�</b>��)<%}else {%> �Ҽ�������Ư�ʹ�<%} %>�� ���� �� 20%�� �� ���� ���� �������ر��� ����ؾ��� �ǹ��� �ֽ��ϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    
	      <% 	}
	} %>					    
				<tr>
			    	<td height=25></td>
			    </tr>
			    
 						    
			    -->
  				<tr>
			    	<td style="font-size : 10pt;">&nbsp;[ǥ4]</td>
			    </tr>
			      <tr>
			    	<td style="font-size : 10pt;" align=left>&nbsp;(���� : ��)&nbsp;</td>
			    </tr>			    
			   
				<tr>
					<td>
						<table width=100% border=0 cellspacing=1 cellpadding=0 bgcolor=#000000 >
							<tr bgcolor=#FFFFFF>
								<td width="20%" align="center" style="font-size : 10pt;">��ȣ</td>
								<td width="10%" align="center" style="font-size : 10pt;">��������</td>
								<td width="10%" align="center" style="font-size : 10pt;">��������</td>
								<td width="20%" align="center" style="font-size : 10pt;">�����Ⱓ</td>
								<td width="30%" align="center" style="font-size : 10pt;">������</td>
							</tr>
							 <% 							
            if(vt_size > 0){
				for(int i=0; i<vt.size(); i++){ 
					
					Hashtable ht = (Hashtable)vt.elementAt(i);					
					
					if(AddUtil.parseInt(String.valueOf(ht.get("AMT5")))==0){
						ht.put("AMT5", String.valueOf(ht.get("AMT3")));						
					}
					
					String i_start_dt = String.valueOf(ht.get("USE_ST"));				   
					String i_end_dt = String.valueOf(ht.get("USE_ET"));
			   
			%>		
							<tr bgcolor=#FFFFFF>
								<td align="center" style="font-size : 10pt;"><%=ht.get("FIRM_NM")%></td>
								<td align="center" style="font-size : 10pt;"><%=ht.get("OUR_CAR_NM")%></td>
								<td align="center" style="font-size : 10pt;"><%=ht.get("CAR_NO")%><br><%=ht.get("CAR_NM")%></td>
								<td align="center" style="font-size : 10pt;"><%=AddUtil.ChangeDate2(i_start_dt)%> ~ <br><%=AddUtil.ChangeDate2(i_end_dt)%><br><%=ht.get("USE_DAY")%>��&nbsp;<%=ht.get("USE_HOUR")%>�ð�</td>
								<td align="center" style="font-size : 10pt;"><%=Util.parseDecimal(Integer.valueOf((String)ht.get("AMT1"))-Integer.valueOf((String)ht.get("AMT2")))%> 
								=((<%=Util.parseDecimal(ht.get("DAY_AMT"))%>��(��)*<%=ht.get("USE_DAY")%>��)+(<%=Util.parseDecimal(ht.get("DAY_AMT"))%>��(��)/24*<%=ht.get("USE_HOUR")%>�ð�))
								<%if(!ht.get("OT_FAULT_PER").equals("100")){%>x<%=Util.parseDecimal(ht.get("OT_FAULT_PER"))%>%<%}%>
								<%if(!ht.get("AMT2").equals("0")){%>-<%=Util.parseDecimal(ht.get("AMT2"))%>��<%}%>
								</td>
							</tr>
								      <% 	}
	} %>	
						</table>
					</td>
				</tr>
				<tr>
			    	<td height=50></td>
			    </tr>
			    <tr> 
			      	<td style="font-weight:bold; font-size:14pt;" colspan="2">��. <span >�� ��</span></td>
			    </tr>
			    <tr>
			    	<td height=25></td>
			    </tr>
			    <tr>
			    	<td colspan="2">�� ��� ���� ���� ��� ���� ���� �������� �� ��� ��Ʈ �̿���� ���ؾ��� ������ �����̶� �� ���̰� �̿� ���� ����� û������ ���� ���� ����ϴ� ���̹Ƿ� �ǰ�� ������ ������ ����� �ݾװ� ������ �ݾװ��� ������ �����ؾ� �� ���Դϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">���� ���� ������ ��� �����Ͻþ� �����ڵ��� �������� ���ظ� ������� �� �ֵ���, ���� �쿬�� ������ ���Ͽ� �ǰ� �δ��� �̵��� ��� ������ ���ظ� ������Ű�� ���� ������, ���� û���� ��� �ο��Ͽ� �ֽñ� �ٶ��ϴ�.</td>
			    </tr>
			    <tr>
			    	<td height=20></td>
			    </tr>
			    <tr>
			    	<td colspan="2">���� �̿� ������ ������� �����߾�������� 2011��10012 �ǰ�, ���� ����������� 2013��51822 �ǰ��� ���� �Ϻ� �¼��Ͽ����ϴ�.</td>
			    </tr>
			</table>
		</td>
	</tr>
</table>
<!--  
<p style='page-break-before:always'><br style="height:0; line-height:0"></P>
<table width='650' border="0" cellpadding="0" cellspacing="0" align=center>
    <tr> 
      	<td height="20"></td>
    </tr>
    <tr>
    	<td align=center style="font-size : 17pt; font-weight:bold;">-------&nbsp; ��&nbsp;&nbsp;&nbsp; ��&nbsp;&nbsp;&nbsp; ��&nbsp;&nbsp;&nbsp; �� &nbsp;-------</td>
    </tr>
    <tr> 
      	<td height="50"></td>
    </tr>
    <tr>
    	<td align=center>
    		<table width="95%" border="0" cellspacing="0" cellpadding="0" class="two">
    		
    		 <% 							
            if(vt_size > 0){
				for(int i=0; i<vt.size(); i++){ 
					
					Hashtable ht = (Hashtable)vt.elementAt(i);					
					
					if(AddUtil.parseInt(String.valueOf(ht.get("AMT5")))==0){
						ht.put("AMT5", String.valueOf(ht.get("AMT3")));						
					}
																	
					%>					    			
					    	<tr>
					    	<td>1. �� ��<%=i+1%>ȣ��  &nbsp;&nbsp;<<%=ht.get("FIRM_NM")%>>��<br> 
					           <%=i+1%>-1ȣ�� �ڵ����뿩�̿��༭, <%=i+1%>-2ȣ�� ���������񽺰�༭, <%=i+1%>-3ȣ�� �ŷ�����, <%=i+1%>-4ȣ�� ���ݰ�꼭.
							</td>
						</tr>
											 
		      <% 	}
	} %>		
	           		
           		<tr>
					<td>1. �� ��<%=vt.size()+1%>ȣ��  &nbsp;&nbsp;�Ƹ���ī �ܱ�뿩���ǥ [2009�� 01�� 15��] ����</td>
           		</tr>
           		<tr>
					<td>1. �� ��<%=vt.size()+2%>ȣ��   &nbsp;&nbsp;������ �Ƹ���ī �ܱ�뿩���ǥ [2011�� 10�� 01��] ����</td>
           		</tr>
           		<tr>
					<td>1. ��  ��<%=vt.size()+3%>ȣ��   &nbsp;&nbsp;������ ���׺� �����ְ�</td>
           		</tr>
           		<tr>
					<td>1. ��  ��<%=vt.size()+4%>ȣ��   &nbsp;&nbsp;���</td>
           		</tr>
			</table>
		</td>
	</tr>
</table>


<p style='page-break-before:always'><br style="height:0; line-height:0"></P>
<table width='650' border="0" cellpadding="0" cellspacing="0" align=center>
    <tr> 
      	<td height="20"></td>
    </tr>
    <tr>
    	<td align=center style="font-size : 17pt; font-weight:bold;">-------&nbsp; ��&nbsp;&nbsp;&nbsp; ��&nbsp;&nbsp;&nbsp; ��&nbsp;&nbsp;&nbsp; �� &nbsp;-------</td>
    </tr>
    <tr> 
      	<td height="50"></td>
    </tr>
    <tr>
    	<td align=center>
    		<table width=100% border=0 cellspacing=1 cellpadding=0  bgcolor=#000000 class="one">
				<tr>
					<td width="15%"  bgcolor=#FFFFFF style="font-size : 10pt;" align="center">������ȣ</td>
					<td width="35%"  bgcolor=#FFFFFF style="font-size : 10pt;" align="center">������</td>
					<td width="50%"  bgcolor=#FFFFFF style="font-size : 10pt;" align="center">��������</td>
				</tr>
    		 <% 							
            if(vt_size > 0){
				for(int i=0; i<vt.size(); i++){ 
					
					Hashtable ht = (Hashtable)vt.elementAt(i);					
					
					if(AddUtil.parseInt(String.valueOf(ht.get("AMT5")))==0){
						ht.put("AMT5", String.valueOf(ht.get("AMT3")));						
					}
																	
					%>					    			
			<tr>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;" align="center">��<%=i+1%>-1ȣ��</td>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;">&nbsp;�ڵ����뿩�̿��༭ ��,��</td>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;">&nbsp;��ⷻƮ ��� ����� �����ϱ� ���� ����.</td>
			</tr>
			<tr>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;" align="center">��<%=i+1%>-2ȣ��</td>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;">&nbsp;���������񽺰�༭</td>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;">&nbsp;������ ���񽺰� �����Ǿ����� �����ϱ� ���� ����.</td>
			</tr>
			<tr>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;" align="center">��<%=i+1%>-3ȣ��</td>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;">&nbsp;�ŷ�����</td>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;">&nbsp;��ü���� ���� ������ ���� ����.</td>
			</tr>			
			<tr>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;" align="center">��<%=i+1%>-4ȣ��</td>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;">&nbsp;���ݰ�꼭</td>
				<td  bgcolor=#FFFFFF style="font-size : 10pt;">&nbsp;��ü���� ���� ������ ���� ����.</td>
			</tr>
		      <% 	}
	} %>		
	           		
			</table>
		</td>
	</tr>
</table>
<p style='page-break-before:always'><br style="height:0; line-height:0"></P>
<table width=650 border=0 cellspacing=0 cellpadding=0 align=center>
	<tr> 
      	<td height="50"></td>
    </tr>
	<tr>
    	<td align=center style="font-size : 17pt; font-weight:bold;">-------&nbsp; ÷&nbsp;&nbsp;&nbsp; ��&nbsp;&nbsp;&nbsp; ��&nbsp;&nbsp;&nbsp; �� &nbsp;-------</td>
    </tr>
    <tr> 
      	<td height="70"></td>
    </tr>
    <tr>
    	<td align=center>
    		<table width="70%" border="0" cellspacing="0" cellpadding="0" class="two">
    			<tr>
    				<td>1. �� �������</td>
    				<td align=right>�� 2��</td>
    			</tr>
    			<tr>
    				<td>1. ���ε��ε</td>
    				<td align=right>�� 1��</td>
    			</tr>
    			<tr>
    				<td>1. ���μ�</td>
    				<td align=right>1��</td>
    			</tr>
    			<tr>
    				<td>1. ����κ�</td>
    				<td align=right>1��</td>
    			</tr>
    		</table>
    	</td>
    </tr>
    <tr>
    	<td height=150></td>
    </tr>
    <tr>
    	<td align=center style="font-size : 15pt; font-weight:bold;"><%=AddUtil.getDate(1)%>.&nbsp;&nbsp;<%=AddUtil.getDate(2)%>.&nbsp;&nbsp;&nbsp;&nbsp;.</td>
    </tr>
    <tr>
    	<td height=100></td>
    </tr>
    <tr>
    	<td align=right style="font-size : 19pt; font-weight:bold;">�ֽ�ȸ�� �Ƹ���ī</td>
    </tr>
    <tr>
    	<td height=40></td>
    </tr>
    <tr>
    	<td align=right style="font-size : 19pt; font-weight:bold;">��ǥ�̻� ������</td>
    </tr>
     <tr>
    	<td height=150></td>
    </tr>
    <tr align="center"> 
      	<td height="40" style="font-size : 20pt;"><b>�� �� �� �� �� �� �� �� &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ��  ��</b></td>
    </tr>    
</table>
-->
</form>
</body>
</html>
