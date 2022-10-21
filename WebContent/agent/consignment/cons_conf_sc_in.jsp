<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.consignment.*, acar.user_mng.*, acar.doc_settle.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/agent/cookies.jsp" %> 

<%
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int count =0;
	
	Vector vt = cs_db.getConsignmentConfList(s_kd, t_wd, gubun1);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;	//����������(20190517)
	
	long total_amt11	= 0;  //�ܺ�Ź�۷�
	long total_amt12	= 0;  //�ܺ�Ź�۷�
	long total_amt13	= 0;  //�ܺ�Ź�۷�
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title ���� */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
		
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<form name='form1' method='post'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/agent/consignment/cons_req_frame.jsp'>
  <input type='hidden' name='cons_no' value=''>
  <input type='hidden' name='mode' value=''>    
  <input type='hidden' name='req_dt' value='<%=AddUtil.getDate()%>'>      
<table border="0" cellspacing="0" cellpadding="0" width='2220'>
  	<tr><td class=line2 colspan="2"></td></tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='18%' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
				  <td width='10%' class='title' style='height:80'>����</td>
		          <td width='25%' class='title'>Ź�۹�ȣ</td>
				  <td width='30%' class='title'>Ź�۾�ü</td>
		          <td width="35%" class='title'>������ȣ</td>
				</tr>
			</table>
		</td>
		<td class='line' width='82%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
		          <td width="50" rowspan="3" class='title'>����</td>				
		          <td width="90" rowspan="3" class='title'>û������</td>
		          <td width="100" rowspan="3" class='title'>����</td>
		          <td width="100" rowspan="3" class='title'>��ȣ</td>				  
				  <td colspan="2" class='title'>���</td>
				  <td colspan="2" class='title'>����</td>
				  <td width='50' rowspan="3" class='title'>����<br>����</td>
				  <td width='60' rowspan="3" class='title'>���<br>����</td>
				  <td width='70' rowspan="3" class='title'>��Ź�۷�</td>				  
				  <td colspan="9" class='title'>û���ݾ�</td>
				  <td width='60' rowspan="3" class='title'>������</td>
				  <td width='60' rowspan="3" class='title'>�Ƿ���</td>
				</tr>
				<tr>
				  <td width='110' rowspan="2" class='title'>���</td>
			      <td width='130' rowspan="2" class='title'>�ð�</td>
			      <td width='110' rowspan="2" class='title'>���</td>
			      <td width='130' rowspan="3" class='title'>�ð�</td>
			      <td width='70' rowspan="3" class='title'>Ź�۷�</td>			
			      <td width='60' rowspan="3" class='title'>������</td>
			      <td width='60' rowspan="3" class='title'>������</td>
			      <td width='60' rowspan="3" class='title'>����<br>������</td>					  
			      <td colspan=4 class='title'>��Ÿ</td>
			      <td width='80' rowspan="3" class='title'>�Ұ�</td>
			  </tr>
			  <tr>
				   <td width='60' class='title'>�ܺ�<br>Ź�۷�</td>				  
				   <td width='60' class='title'>������</td>
				   <td width='60' class='title'>��������<br/>����</td>
				   <td width='60' class='title'>�˻����</td>		
			  </tr>
			</table>
		</td>
	</tr>
<%	if(vt_size > 0)	{%>
	<tr>
		<td class='line' width='18%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			//DocSettleBean doc 		= d_db.getDocSettle(String.valueOf(ht.get("DOC_NO")));
			//String doc_bit = "5";
			//boolean flag1 = true;
			//=====[doc_settle] update=====
			//flag1 = d_db.updateDocSettleDtNull(String.valueOf(ht.get("DOC_NO")), doc_bit);
			//flag1 = d_db.updateDocSettle(String.valueOf(ht.get("DOC_NO")), doc.getUser_id2(), doc_bit, doc_step);
			
			String prev_car_no = String.valueOf(ht.get("CAR_NO"));
			String seq = String.valueOf(ht.get("SEQ"));
			String car_no = "";
			if( prev_car_no.length() > 10 ) {
				car_no = cs_db.getCarNo(String.valueOf(ht.get("CONS_NO")), Integer.parseInt(seq));
			}
			car_no = car_no == "" ? prev_car_no : car_no;
			%>
				<tr>
					<td  width='10%' align='center'><%=i+1%></td>
					<td  width='25%' align='center'><a href="javascript:parent.view_cons('<%=ht.get("CONS_NO")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CONS_NO")%>-<%=ht.get("SEQ")%></a></td>					
					<td  width='30%' align='center'><%=ht.get("OFF_NM")%></td>
					<td  width='35%' align='center'><%=car_no%></td>
				</tr>
<%		}%>
				<tr>
				  <td class='title'>&nbsp;</td>
				  <td class='title'>&nbsp;</td>
				  <td class='title'>&nbsp;</td>
				  <td class='title'>&nbsp;</td>
				</tr>
			</table>
		</td>
		<td class='line' width='82%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			%>
				<tr>											
					<td  width='50' align='center'><%=ht.get("CONS_ST_NM")%></td>				
					<td  width='90' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>									
					<td  width='100' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 8)%></span></td>
					<td  width='100' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%></span></td>
					<td  width='110' align='center'><span title='<%=ht.get("FROM_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("FROM_PLACE")), 6)%></span></td>
					<td  width='130' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("FROM_DT")))%></td>
					<td  width='110' align='center'><span title='<%=ht.get("TO_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("TO_PLACE")), 6)%></span></td>
					<td  width='130' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("TO_DT")))%></td>
					<td  width='50' align='center'><%=ht.get("PAY_ST_NM")%></td>
					<td  width='60' align='center'><%=ht.get("COST_ST_NM")%></td>		
					<td  width='70' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CUST_AMT")))%></td>
					
					<td  width='70' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_AMT")))%></td>	
							
					<td  width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OIL_AMT")))%></td>					
					<td  width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_AMT")))%></td>
					<td  width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_FEE")))%></td>
					<td  width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_OTHER_AMT")))%></td>		
					<td  width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OTHER_AMT")))%></td>
					<td  width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("ETC1_AMT")))%></td>		
					<td  width='60' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("ETC2_AMT")))%></td>		
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>
					<td width='60' align='center'><span title='<%=ht.get("DRIVER_NM")%>'><%=Util.subData(String.valueOf(ht.get("DRIVER_NM")), 3)%></span></td>
					<td width='60' align='center'><%=ht.get("USER_NM1")%></td>
				</tr>
<%			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CONS_AMT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("WASH_AMT")));
			total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("OTHER_AMT")));
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("HIPASS_AMT")));
			total_amt8 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("WASH_FEE")));
			
			total_amt11 	= total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("CONS_OTHER_AMT")));
			total_amt12 	= total_amt12 + AddUtil.parseLong(String.valueOf(ht.get("ETC1_AMT")));
			total_amt13 	= total_amt13 + AddUtil.parseLong(String.valueOf(ht.get("ETC2_AMT")));
		}%>
				<tr>						
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>					
				    <td class='title'>&nbsp;</td>					
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
					<td class='title_num'><%=Util.parseDecimal(total_amt1)%></td>									
					<td class='title_num'><%=Util.parseDecimal(total_amt2)%></td>
					<td class='title_num'><%=Util.parseDecimal(total_amt3)%></td>
					<td class='title_num'><%=Util.parseDecimal(total_amt8)%></td>				
					<td class='title_num'><%=Util.parseDecimal(total_amt11)%></td>				
					<td class='title_num'><%=Util.parseDecimal(total_amt4)%></td>
					<td class='title_num'><%=Util.parseDecimal(total_amt12)%></td>		
					<td class='title_num'><%=Util.parseDecimal(total_amt13)%></td>		
					<td class='title_num'><%=Util.parseDecimal(total_amt5)%></td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				</tr>
			</table>
		</td>
<%	}else{%>
	<tr>
		<td class='line' width='18%' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>�˻�� �Է��Ͻʽÿ�.
					<%}else{%>��ϵ� ����Ÿ�� �����ϴ�<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='82%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%	}%>
</table>
</form>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
