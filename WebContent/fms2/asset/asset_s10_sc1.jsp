<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.asset.*, acar.util.* , acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String st 	= request.getParameter("st")==null?"1":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"car_no":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String first 	= request.getParameter("first")==null?"":request.getParameter("first");
	
	String gubun1 	= request.getParameter("gubun1")==null?"2019":request.getParameter("gubun1");   //�⵵ 
	String gubun2 	= request.getParameter("gubun2")==null?"L":request.getParameter("gubun2");    //����: L:lease, R:rent
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int count =0;

	AssetDatabase as_db = AssetDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
			
	//�ڻ�󰢾�
	Vector vt = as_db.getAssetCarStat1(gubun1, gubun2, gubun, gubun_nm);

	int cont_size = vt.size();
	
	long t_amt1[] = new long[1];  //���ʰ���
    long t_amt2[] = new long[1];  //��� ����
    long t_amt3[] = new long[1];  //���� ����
    long t_amt4[] = new long[1];  // ��� ����
    long t_amt5[] = new long[1];  //���� ����
    long t_amt6[] = new long[1];  //���⸻ ����
    long t_amt7[] = new long[1];  //��⸻�� ��ΰ���
    long t_amt8[] = new long[1]; //�󰢾�
    long t_amt9[] = new long[1]; 
    long t_amt10[] = new long[1]; //�Ű���  
    long t_amt11[] = new long[1]; //���ź�����  
    long t_amt12[] = new long[1]; //���⸻ ���ź�����  
    long t_amt13[] = new long[1]; //��⸻ ���ź�����  
    long t_amt14[] = new long[1]; //���ź����� ���� 
    long t_amt15[] = new long[1]; //���ź����� ���� 
    long t_amt16[] = new long[1]; //�Ű���
  	   
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
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
	
	//����ϱ�
	function toExcel(){
		var fm = document.form1;
		fm.target = "_blank";
		
		fm.action = "popup_asset_s10_excel1.jsp";
		fm.submit();
	}
//-->
</script>
</head>
<body onLoad="javascript:init()">

  
<table border="0" cellspacing="0" cellpadding="0" width='2100'>
	<tr><td>&nbsp;
				<%if( nm_db.getWorkAuthUser("������",user_id) ){%>	
					&nbsp;<a href="javascript:toExcel()">����Ʈ���� </a>
				<%} %>
			  
		</td>	  	
  </tr>
  <tr>
   	<td colspan=2 class=line2></td>
   </tr> 
  <tr id='tr_title' style='position:relative;z-index:1' >		
    <td class='line' width='24%' id='td_title' style='position:relative;' > 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr> 
          <td width='7%' class='title'>����</td>
          <td width='12%' class='title'>�ڻ��ڵ�</td>
          <td width='28%' class='title'>�ڻ��</td>
          <td width='18%' class='title'>������ȣ</td>
          <td width="15%" class='title'>�������</td>      
        </tr>
      </table>
	</td>
	<td class='line' width='76%' >
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		  <td width="7%" class='title'>���ʰ���</td>
		  <td width="7%" class='title'>���⸻����</td>	
		  <td width="6%" class='title'>���⸻������</td>	
		  <td width="7%" class='title'>�������</td>	
		  <td width="6%" class='title'>����������</td>	
		  <td width="6%" class='title'>��������</td>			  
	      <td width='6%' class='title'>��Ⱘ��</td>
	      <td width='6%' class='title'>���ݰ���</td>
	      <td width='5%' class='title'>�����ݰ���</td>
	      <td width="7%" class='title'>�Ϲݻ󰢾�</td>		
	      <td width="6%" class='title'>���ź�����</td>		
	      <td width="7%" class='title'>��⸻����</td>		 
	      <td width="6%" class='title'>��⸻������</td>		 
	      <td width="7%" class='title'>��⸻��ΰ���</td>	
	      <td width="5%" class='title'>�Ű���</td>	
	      <td width="6%" class='title'>�Ű��ݾ�</td>	
	     	   	 
		</tr>
	  </table>
	</td>
  </tr>
  <%if(cont_size > 0){%>
  <tr>		
    <td class='line' width='24%' id='td_con' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String td_color = "";
			%>
        <tr> 
          <td <%=td_color%> width='7%' align='center'><%=i+1%></td>
          <td <%=td_color%> width='12%' align='center'><a href="javascript:parent.view_asset('<%=ht.get("ASSET_CODE")%>')" onMouseOver="window.status=''; return true"><%=ht.get("ASSET_CODE")%></a></td>
          <td <%=td_color%> width='28%' align='center'><span title='<%=String.valueOf(ht.get("ASSET_NAME"))%>'><%=Util.subData(String.valueOf(ht.get("ASSET_NAME")), 12)%></span></td>
          <td <%=td_color%> width='18%' align='center'><%=ht.get("CAR_NO")%></td>		
          <td <%=td_color%> width='15%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("GET_DATE")))%></td>     
       
        </tr>
        <%		}	%>
        <tr> 
           <td class=title style='text-align:center;' colspan="5" >�հ�</td>
         </tr>
      </table>
	</td>
	<td class='line' width='76%'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < cont_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				
				String td_color = "";
										
				long t1=0;
				long t2=0;
				long t3=0;
				long t4=0;
				long t5=0;
				long t6=0;
				long t7=0;
				long t8=0;
				long t9=0;
				long t10=0;  //�Ű���  
				long t11=0;  //���ź����ݻ󰢾� 
				long t12=0;  //���⸻ ���ź����� 
				long t13=0;  //��⸻ ���ź����� 
				long t14=0;  //���ź����ݰ��� 
				long t15=0;  //���ź��������� 
				long t16=0;  //�Ű� 											
				
				t1=AddUtil.parseLong(String.valueOf(ht.get("T1")));
				t2=AddUtil.parseLong(String.valueOf(ht.get("T2")));
				t3=AddUtil.parseLong(String.valueOf(ht.get("T3")));
				t4=AddUtil.parseLong(String.valueOf(ht.get("T4")));
				t5=AddUtil.parseLong(String.valueOf(ht.get("T5")));
				t6=AddUtil.parseLong(String.valueOf(ht.get("T6")));
				t7=AddUtil.parseLong(String.valueOf(ht.get("T7")));
				t8=AddUtil.parseLong(String.valueOf(ht.get("T8")));
				t9=AddUtil.parseLong(String.valueOf(ht.get("T9")));
				t10=AddUtil.parseLong(String.valueOf(ht.get("T10")));
				t11=AddUtil.parseLong(String.valueOf(ht.get("T11")));
				t12=AddUtil.parseLong(String.valueOf(ht.get("T12")));
				t13=AddUtil.parseLong(String.valueOf(ht.get("T13")));
				t14=AddUtil.parseLong(String.valueOf(ht.get("T14")));
				t15=AddUtil.parseLong(String.valueOf(ht.get("T15")));
				t16=AddUtil.parseLong(String.valueOf(ht.get("SALE_AMT")));
										
				for(int j=0; j<1; j++){
				
						t_amt1[j] += t1;
						t_amt2[j] += t2;
						t_amt3[j] += t3;
						t_amt4[j] += t4;
						t_amt5[j] += t5;
						t_amt6[j] += t6;
						t_amt7[j] += t7;
						t_amt8[j] += t8;
						t_amt9[j] += t9;
						t_amt11[j] += t11;
						t_amt12[j] += t12;
						t_amt13[j] += t13;
						t_amt14[j] += t14;
						t_amt15[j] += t15;	
						t_amt16[j] += t16;	
				}
				
		%>
		<tr>
		  <td <%=td_color%>  width="7%" align='right'><%=Util.parseDecimal(t1)%></td> <!-- ���ʰ��� -->
		  <td <%=td_color%>  width="7%" align='right'><%=Util.parseDecimal(t6)%></td>	<!-- ���⸻ ���� -->	
		  <td <%=td_color%>  width="6%" align='right'><%=Util.parseDecimal(t12)%></td> <!--���⸻ ���ź����� -->		
		  <td <%=td_color%>  width="7%" align='right'><%=Util.parseDecimal(t2)%></td>	<!-- ������� -->		
		  <td <%=td_color%>  width="6%" align='right'><%=Util.parseDecimal(t15)%></td>	<!-- ���������� -->				
		  <td <%=td_color%>  width="6%" align='right'><%=Util.parseDecimal(t3)%></td>  <!-- ��� ���� ���� -->
		  <td <%=td_color%>  width="6%" align='right'><%=Util.parseDecimal(t4)%></td>   <!--��� ���� -->
		  <td <%=td_color%>  width='6%' align='right'><%=Util.parseDecimal(t5)%></td>   <!-- ��� ���� ���� -->
		  <td <%=td_color%>  width='5%' align='right'><%=Util.parseDecimal(t14)%></td>   <!-- ��� ������ ���� -->
		  <td <%=td_color%>  width='7%' align='right'><%=Util.parseDecimal(t8)%></td>	<!-- �Ϲݻ󰢾� -->
		  <td <%=td_color%>  width='6%' align='right'><%=Util.parseDecimal(t11)%></td>  <!-- ���ź����� -->
		  <td <%=td_color%>  width='7%' align='right'><%=Util.parseDecimal(t9)%></td>	 <!-- ��⸻ ���� -->
		  <td <%=td_color%>  width='6%' align='right'><%=Util.parseDecimal(t13)%></td>	 <!--��⸻ ���ź�����  -->
		  <td <%=td_color%>  width='7%' align='right'><%=Util.parseDecimal(t7)%></td>  <!-- ��ΰ��� -->	
		  <td <%=td_color%>  width='5%' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("SALE_DATE")))%></td>  <!-- �Ű���  -->		
		  <td <%=td_color%>  width='6%' align='right'><%=Util.parseDecimal(t16)%></td>  <!-- �Ű��� -->			
			
		</tr>
<%		}	%>
		<tr>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt1[0])%></td>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt6[0])%></td>	
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt12[0])%></td>		
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt2[0])%></td>	
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt15[0])%></td>	 		  			
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt3[0])%></td>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt4[0])%></td>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt5[0])%></td>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt14[0])%></td>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt8[0])%></td>		 
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt11[0])%></td>		 
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt9[0])%></td>		
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt13[0])%></td>		
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt7[0])%></td>	
		  <td class=title style='text-align:right;'></td>
		  <td class=title style='text-align:right;'><%=Util.parseDecimal(t_amt16[0])%></td>	
			
		</tr>
	  </table>
	</td>
<%	}else{	%>                     
  <tr>		
    <td class='line' width='24%' id='td_con' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr> 
          <td align='center'><%if(st.equals("")){%>�˻�� �Է��Ͻʽÿ�.<%}else{%>��ϵ� ����Ÿ�� �����ϴ�<%}%></td>
        </tr>
      </table>
	</td>
	<td class='line' width='76%'>			
      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
		  <td>&nbsp;</td>
		</tr>
  	  </table>
	</td>
  </tr>
<%	}	%>
</table>

<form action="./asset_s10_frame.jsp" name="form1" method="POST">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
   <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
</form>
</body>
</html>


