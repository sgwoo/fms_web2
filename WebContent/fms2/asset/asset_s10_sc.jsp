<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.asset.*,acar.user_mng.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");

	String gubun1 	= request.getParameter("gubun1")==null?"2016":request.getParameter("gubun1");   //�⵵ 
	String gubun2 	= request.getParameter("gubun2")==null?"L":request.getParameter("gubun2");    //����: L:lease, R:rent
	
	String gubun 		= request.getParameter("gubun")==null?"car_no":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 2; //sc ��¶��μ�
	
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-70;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AssetDatabase as_db = AssetDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//�ڻ�󰢾�
	Vector vt = as_db.getAssetCarStat(gubun1, gubun2, gubun, gubun_nm);
	int asset_size = vt.size();		
			
	long t_amt1[] = new long[1];  //���ʰ���
    long t_amt2[] = new long[1];  
    long t_amt3[] = new long[1];  
    long t_amt4[] = new long[1];  
    long t_amt5[] = new long[1];  
    long t_amt6[] = new long[1];  
    long t_amt7[] = new long[1];   //��⸻ ����  
    long t_amt8[] = new long[1];   //���⸻ ����
     long t_amt9[] = new long[1];   //
    long t_amt11[] = new long[1];   //���⸻���ź�����   
    long t_amt12[] = new long[1];   //���ź�����   
    long t_amt13[] = new long[1];   //��⸻ ���ź�����   
     long t_amt14[] = new long[1];   //������ �Ű��� ���ź����� �ܾ�    
     
    long t100_amt[] = new long[1];   //�Ӵ��    
    long t90_amt[] = new long[1];   //�Ӵ��    
    long t80_amt[] = new long[1];   //�Ӵ��    
    long t70_amt[] = new long[1];   //�Ӵ��    
    
    long est1_amt[] = new long[1];   //�ݿ����� ��ΰ���
    long est2_amt[] = new long[1];   //�ݿ����� ��ΰ���
    long est3_amt[] = new long[1];   //�ݿ����� ��ΰ���
    long est4_amt[] = new long[1];   //�ݿ����� ��ΰ���
    
    long est1_amt_120[] = new long[1];   //�ݿ����� ��ΰ��� (�ѵ� 120%)
    long est2_amt_120[] = new long[1];   //�ݿ����� ��ΰ���
    long est3_amt_120[] = new long[1];   //�ݿ����� ��ΰ���
    long est4_amt_120[] = new long[1];   //�ݿ����� ��ΰ���
       
    long t_amt10[] = new long[1];   //�Ű�ó�п���    
    long t_p_amt6[] = new long[1];  
    long t_m_amt6[] = new long[1];   
    
    //20170207 ����ó��
    String content_code = "OFF_DOC";
	String content_seq  = "asset"+gubun1;
	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();	
	   	
%>


<html style="overflow: hidden;">
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript" src="/include/table_fix.js?ver=0.2"></script>
<link rel="stylesheet" type="text/css" href="/include/table_t.css?ver=0.2">
<link rel="stylesheet" type="text/css" href="/include/table_fix.css?ver=0.2">

<script language='javascript'>
<!--
 	//��ĵ���
	function scan_reg(docs_menu){
		window.open("/fms2/off_doc/reg_scan.jsp?docs_menu=asset&syear=<%=gubun1%>", "SCAN", "left=10, top=10, width=720, height=400, scrollbars=yes, status=yes, resizable=yes");
	}	
	
//����ϱ�
function toExcel(){
	var fm = document.form1;
	fm.target = "_blank";
	
	fm.action = "popup_asset_s10_excel.jsp";
	fm.submit();
}
//-->
</script>
</head>

<body leftmargin="15">
<form  name="form1"  id="form1"  method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
   <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='asset_code' value=''>
  <input type='hidden' name='height' id="height" value='<%=height%>'>
  
   <table border="0" cellspacing="0" cellpadding="0" width='2000'>
   	<tr><td>&nbsp;
   	 <%if(attach_vt_size > 0 && !gubun1.equals("") ){
			  	  		for (int j = 0 ; j < attach_vt_size ; j++){
			  				Hashtable ht = (Hashtable)attach_vt.elementAt(j);%>
			  <a href="https://fms3.amazoncar.co.kr/fms2/attach/download.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_excel.gif" align="absmiddle" border="0"></a>&nbsp;
			  				<%if( nm_db.getWorkAuthUser("������",user_id) ){%>			
			  					<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_delete.gif" align="absmiddle" border="0"></a>
			  					&nbsp;<a href="javascript:toExcel()">����Ʈ���� </a>
							<%} } }else{%>
			  	<%if( nm_db.getWorkAuthUser("������",user_id) ){%>			
			  		<a href="javascript:scan_reg('<%=content_seq%>')"><img src="/acar/images/center/button_reg_exfile.gif" align="absmiddle" border="0"></a>
			  		
			  	<%}}%>
		</td>	  	
  </tr>
  <tr>
  	<!-- <td  colspan=2>  �Ӵ�� ����: 1) ������ + ������ �Ӵ�� ȯ��ݾ�,  2) ������ + ������ �Ӵ�� ȯ��ݾ� (���� �ʰ��� ���� 100%),  3) ������ + �����ܿ��뿩�Ⱓ �뿩�� ȯ��ݾ�  ,  4) ������ + �����ܿ��뿩�Ⱓ �뿩�� ȯ��ݾ� - �������ʰ����� ���������� ó��  
  		</td> -->  		
  		<td  colspan=2>  �Ӵ�� ���� :&nbsp;&nbsp;&nbsp;  1)������ + ������ �Ӵ� ȯ��ݾ� (������ ����) &nbsp;&nbsp;&nbsp;  2)������ + ������ �Ӵ� ȯ��ݾ� (������ ������) &nbsp;&nbsp;&nbsp;  3)������ 10% + ������ �Ӵ� ȯ��ݾ� (������ ����) &nbsp;&nbsp;&nbsp;  4)������ 10% + ������ �Ӵ� ȯ��ݾ� (������ ������) 
  		</td>
  </tr>
  </table>

 <div class="tb_wrap">
	<div class="tb_title_box custom_scroll">
		<table class="tb">
			<tr>
				<td style="width: 560px;">
					<div style="width: 560px;">
						<table class="inner_top_table left_fix" style="height: 60px;">
							<tr>
							  <td class='title title_border' rowspan=2 with=10%>����</td>        
							  <td width='15%'  rowspan=2 class='title title_border'>�ڻ��ڵ�</td>
					          <td width='45%'  rowspan=2 class='title title_border'>�ڻ��</td> 
					          <td width="15%"  rowspan=2 class='title title_border'>�������</td>
					          <td width="15%"  rowspan=2 class='title title_border'>�Ű�����</td>       
             
							</tr>
						</table>
					</div>
				</td>
				<td >	
					<div>	
						<table class="inner_top_table table_layout" style="height: 60px;">		
						   <colgroup>			               
				       			<col width="100">
				       			<col width="100">
				       			<col width="100">				       		
				       			<col width="100">		       			
				       			<col width="100">		       			
				       			<col width="100">
				       			<col width="100">
				       			<col width="100">
				       			<col width="110">				       		
				       			<col width="110">		       			
				       			<col width="110">		       			
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">
				       			<col width="110">
				       			<col width="100">
				       			<col width="100">		
				       		</colgroup>
				       		 
			          	  	<tr>
							  <td width="100"  rowspan=2 class='title title_border' >��氡��</td>
							  <td width="100"   rowspan=2 class='title title_border'>���⸻����</td>		
							  <td width="100"   rowspan=2 class='title title_border'>���⸻������</td>		
							  <td width="100"   rowspan=2 class='title title_border'>�Ϲݻ󰢾�</td>		
							  <td width="100"  rowspan=2 class='title title_border'>���ź����� </td>		
						      <td width="100"  rowspan=2 class='title title_border'>��⸻����</td>	
						      <td width="100"  rowspan=2 class='title title_border'>�������ܾ�(�Ű�)</td>	
						      <td width="100"  rowspan=2 class='title title_border'>��⸻������</td>	 
							  <td width="110"  rowspan=2 class='title title_border'>��⸻��ΰ���</td>
							  <td class='title title_border' colspan=4>�Ӵ��</td>
							  <td class='title title_border' colspan=4>�ݿ�������ΰ���</td>
							  <td class='title title_border' colspan=4>�ݿ�������ΰ���(�ѵ�120%)</td>								
							  <td width="100"  rowspan=2 class='title title_border'>�Ű���</td>	     			   	
							  <td width="100"  rowspan=2 class='title title_border'>����</td>	  	   			   	  
							</tr>
							<tr>
							  <td width="110" class='title title_border'>1</td>
							  <td width="110" class='title title_border'>2</td>	
							  <td width="110" class='title title_border'>3</td>	
							  <td width="110" class='title title_border'>4</td>		
							  <td width="110" class='title title_border'>1</td>
							  <td width="110" class='title title_border'>2</td>	
							  <td width="110" class='title title_border'>3</td>	
							  <td width="110" class='title title_border'>4</td>	
							  <td width="110" class='title title_border'>1</td>
							  <td width="110" class='title title_border'>2</td>	
							  <td width="110" class='title title_border'>3</td>	
							  <td width="110" class='title title_border'>4</td>									   			   	  
						</tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="tb_box">
		<table class="tb">
			<tr>
				<td style="width: 560px;">
					<div style="width: 560px;">
						<table class="inner_top_table left_fix"> 
  <% //if(asset_size > 0){%> 
        <%	for(int i = 0 ; i < asset_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
	%>			
					        <tr> 
					          <td  width='10%'  class="content_border center" ><%=i+1%></td>
					          <td  width='15%' class="content_border center"><%=ht.get("ASSET_CODE")%></td>
					          <td  width='45%' class="content_border center"><span title='<%=String.valueOf(ht.get("ASSET_NAME"))%>'><%=Util.subData(String.valueOf(ht.get("ASSET_NAME")), 16)%></span></td>
					          <td  width='15%' class="content_border center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("GET_DATE")))%></td>
					          <td  width='15%' class="content_border center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("SALE_DATE")))%></td>					             
					        </tr>
					        <%		}	%>
					        <tr> 
					           <td class='title_p title_border' style='text-align:center;' colspan="5" >�հ�</td>
					         </tr>
					        <tr> 
					           <td class='title_p title_border' style='text-align:center;' colspan="5" ></td>
					        </tr>
					     </table>
					 </div>            
				 </td>   <!-- left -->   
				 
				<td >	
   				    <div >	
					  <table class="inner_top_table table_layout">	
        <%	for(int i = 0 ; i < asset_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
							
				long t1=0;  //����
				long t2=0;  //�Ϲݻ󰢾�
				long t3=0;  //���ݴ����
				long t4=0; //��ΰ���
				long t5=0; //�Ű���
				long t6=0;  //���� 
				long t7=0;  //
				long t8=0;  //���⸻ ����
				long t9=0;  //
				long t11=0;    //���⸻���ź�����   
				long t12=0;     //���ź�����   
				long t13=0;  //��⸻ ���ź�����   
			    long t10=0;  //�Ű� ó�� ����   
			    long t14=0;  //������ �Ű��� ���ź����� �ܾ�    
			   
			    long t100=0;  //�Ӵ�� �ݿ� 
			    long t90 =0;  //�Ӵ�� �ݿ� 
			    long t80=0;  //�Ӵ�� �ݿ� 
			    long t70=0;  //�Ӵ�� �ݿ� 
			    
			    long est1=0;  //�ݿ�������ΰ��� 
			    long est2=0;  //�ݿ�������ΰ��� 
			    long est3=0;  //�ݿ�������ΰ��� 
			    long est4=0;  //�ݿ�������ΰ��� 
			    
			    long est1_120=0;  //�ݿ�������ΰ��� 
			    long est2_120=0;  //�ݿ�������ΰ��� 
			    long est3_120=0;  //�ݿ�������ΰ��� 
			    long est4_120=0;  //�ݿ�������ΰ��� 
			       
				long sale_dt = 0;
								
     		   t1 = AddUtil.parseLong(String.valueOf(ht.get("GET_AMT")));     
				t2=AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT")));
			   t3 = AddUtil.parseLong(String.valueOf(ht.get("ADEP_AMT")));     
		//		t4=AddUtil.parseLong(String.valueOf(ht.get("JANGBU_AMT")));
				t5=AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));
				
			  	t8=AddUtil.parseLong(String.valueOf(ht.get("JUN_RESER")));
			  	t11=AddUtil.parseLong(String.valueOf(ht.get("JUN_GDEP")));
			  	t12=AddUtil.parseLong(String.valueOf(ht.get("GDEP_MAMT")));
			  	t13=AddUtil.parseLong(String.valueOf(ht.get("GDEP_AMT")));
			 
				sale_dt=AddUtil.parseLong(String.valueOf(ht.get("SALE_DATE")));
				
				t100=AddUtil.parseLong(String.valueOf(ht.get("ACCOUNT_TAX_AMT1")));
				t90=AddUtil.parseLong(String.valueOf(ht.get("ACCOUNT_TAX_AMT2")));
				t80=AddUtil.parseLong(String.valueOf(ht.get("ACCOUNT_TAX_AMT3")));
				t70=AddUtil.parseLong(String.valueOf(ht.get("ACCOUNT_TAX_AMT4")));
				
				
				if ( sale_dt >0) {				
					t6=t5 - t1 + t3 + t13 ;
			      t14 = t13;
					t3  = 0;
				   t4 = 0; //��ΰ��� 
				 
				   t7= 0;   //��⸻����
                t9=0;    //��⸻ ���ź����� 
                t10 = t1 - t8 - t2  -  t13;
                t13 = 0;
               	
                
				} else {
				   t6 = 0;				
				   t4 = t1 - t3 - t13;  
				   t7= t3;
				   t9 =t13;
				   t10 = 0;  
				} 
				
				if ( t4 > t100  ) {						
					est1  = t4;	
					est1_120  = t4;	
				} else  {
					if ( t4*1.2 > t100) {
						est1  = t100;	
						est1_120  =t100;	
					} else {
						est1  = t100;
						est1_120  =  t4*120/100;	
					}				
				}
				
				if ( t4 > t90  ) {						
					est2  = t4;	
					est2_120  = t4;	
				} else  {
					if ( t4*1.2 > t90) {
						est2  = t90;	
						est2_120  =t90;	
					} else {
						est2  = t90;
						est2_120  = t4*120/100;
					}				
				}
				
				if ( t4 > t80  ) {						
					est3  = t4;	
					est3_120  = t4;	
				} else  {
					if ( t4*1.2 > t80) {
						est3  = t80;	
						est3_120  =t80;	
					} else {
						est3  = t80;
						est3_120  = t4*120/100;
					}				
				}
												
				if ( t4 > t70  ) {						
					est4  = t4;	
					est4_120  = t4;	
				} else  {
					if ( t4*1.2 > t70) {
						est4  = t70;	
						est4_120  =t70;	
					} else {
						est4  = t70;
						est4_120  = t4*120/100;
					}				
				}
													
				
				for(int j=0; j<1; j++){
						t_amt1[j] += t1;
						t_amt2[j] += t2;
						t_amt3[j] += t3;
						t_amt4[j] += t4;  //��ΰ��� 
						t_amt5[j] += t5;  //�Ű��� 
						t_amt6[j] += t6;  //���� 
						t_amt7[j] += t7;
						t_amt8[j] += t8;     //���⸻ ���� 						
						t_amt9[j] += t9;     //���⸻ ���� 
						t_amt11[j] += t11;   //���⸻ ���ź����� 
						t_amt12[j] += t12;   //���ź����� 
						t_amt13[j] += t13;   //��⸻ ���ź����� 
						t_amt14[j] += t14;   //��⸻ ���ź����� 
						
						t_amt10[j] += t10;   //�Ű� ����   (��ΰ���) 
						
						t100_amt[j] += t100;   //�Ӵ�� 
						t90_amt[j] += t90;   //�Ӵ�� 
						t80_amt[j] += t80;   //�Ӵ�� 
						t70_amt[j] += t70;   //�Ӵ�� 
													
						if ( t6 >=0 ) {
							t_p_amt6[j] += t6;
						} else {
							t_m_amt6[j] += t6;
						}
												
						est1_amt[j] += est1;   //�ݿ����� ��ΰ��� 
						est2_amt[j] += est2;   //�ݿ����� ��ΰ��� 
						est3_amt[j] += est3;   //�ݿ����� ��ΰ��� 
						est4_amt[j] += est4;   //�ݿ����� ��ΰ��� 
						
						est1_amt_120[j] += est1_120;   //�ݿ����� ��ΰ��� (���� 120%)
						est2_amt_120[j] += est2_120;   //�ݿ����� ��ΰ��� 
						est3_amt_120[j] += est3_120;   //�ݿ����� ��ΰ��� 
						est4_amt_120[j] += est4_120;   //�ݿ����� ��ΰ��� 
									
				}
				
		%>
						<tr>
						  <td  width='100' class='content_border right' ><%=Util.parseDecimal(t1)%></td> 
						  <td  width='100' class='content_border right'><%=Util.parseDecimal(t8)%></td>		 
						  <td  width='100' class='content_border right'><%=Util.parseDecimal(t11)%></td>		
						  <td  width='100' class='content_border right'><%=Util.parseDecimal(t2)%></td>		
						  <td  width='100' class='content_border right'><%=Util.parseDecimal(t12)%></td>		 <!--���ź����� -->
						  <td  width='100' class='content_border right'><%=Util.parseDecimal(t7)%></td>	<!--��⸻ ���� -->
						  <td  width='100' class='content_border right'><%=Util.parseDecimal(t14)%></td>	<!--���ź����� �ܾ�(�Ű�) -->
						  <td  width='100' class='content_border right'><%=Util.parseDecimal(t9)%></td>	<!-- ��⸻ ���ź����� -->			
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(t4)%></td>  <!--��ΰ��� -->	
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(t100)%></td>  <!--  �Ӵ�� -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(t90)%></td>  <!--  �Ӵ�� -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(t80)%></td>  <!--  �Ӵ�� -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(t70)%></td>  <!--  �Ӵ�� -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(est1)%></td>  <!--  �ݿ����� ��ΰ��� -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(est2)%></td>  <!--  �ݿ����� ��ΰ��� -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(est3)%></td>  <!--  �ݿ����� ��ΰ��� -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(est4)%></td>  <!--  �ݿ����� ��ΰ��� -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(est1_120)%></td>  <!--  �ݿ����� ��ΰ��� (120%�ѵ�)-->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(est2_120)%></td>  <!--  �ݿ����� ��ΰ��� -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(est3_120)%></td>  <!--  �ݿ����� ��ΰ��� -->
						  <td  width='110' class='content_border right'><%=Util.parseDecimal(est4_120)%></td>  <!--  �ݿ����� ��ΰ��� -->
						  <td  width='100' class='content_border right'><%=Util.parseDecimal(t5)%></td>  <!--�Ű��� -->
						  <td  width='100' class='content_border right'><%=Util.parseDecimal(t6)%></td>  <!--���� -->		
							
						</tr>
				<%		}	%>
						<tr>
						  <td  width='100' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt1[0])%></td>
						  <td  width='100' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt8[0])%></td>	
						  <td  width='100' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt11[0])%></td>	
						  <td   width='100'class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt2[0])%></td>	
						  <td  width='100' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt12[0])%></td>	
						  <td  width='100' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt7[0])%></td>	
						  <td  width='100'class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt14[0])%></td>	
						  <td  width='100' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt9[0])%></td>				
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt4[0])%></td>
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t100_amt[0])%></td>		
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t90_amt[0])%></td>		
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t80_amt[0])%></td>		
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t70_amt[0])%></td>	
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(est1_amt[0])%></td>		
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(est2_amt[0])%></td>	
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(est3_amt[0])%></td>	
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(est4_amt[0])%></td>	
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(est1_amt_120[0])%></td>		
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(est2_amt_120[0])%></td>	
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(est3_amt_120[0])%></td>	
						  <td  width='110' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(est4_amt_120[0])%></td>	
						  <td  width='100' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt5[0])%></td>		
						  <td  width='100' class='title_p title_border' style='text-align:right;'><%=Util.parseDecimal(t_amt6[0])%></td>				  	
						</tr>
						<tr>
						  <td  colspan=14 class='title_p title_border' style='text-align:right;'></td>	
						  <td  colspan=2 class='title_p title_border' style='text-align:right;'>ó�м���:<%=Util.parseDecimal(t_amt5[0])%></td>
						  <td  colspan=3 class='title_p title_border' style='text-align:right;'>ó�п���:<%=Util.parseDecimal(t_amt10[0])%></td>				
						  <td  colspan=2 class='title_p title_border' style='text-align:right;'>ó������:<%=Util.parseDecimal(t_p_amt6[0])%></td>
						  <td  colspan=2 class='title_p title_border' style='text-align:right;'>ó�мս�:<%=Util.parseDecimal(t_m_amt6[0] * (-1))%></td>	  	
						</tr>
					  </table>			
				  </div>
			   </td>
			</tr>
	   </table>
	</div>
</div>
</form>

</body>
</html>
