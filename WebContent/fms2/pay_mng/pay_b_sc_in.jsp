<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int count =0;
	
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	
	Vector vt =  pm_db.getPayBList(s_kd, t_wd, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
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
	
	//��ü����
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
		return;
	}			
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='req_dt'    value=''>      
  <input type='hidden' name='from_page' value='/fms2/pay_mng/pay_b_frame.jsp'>  
<table border="0" cellspacing="0" cellpadding="0" width='1410'>
  <tr id='tr_title' style='position:relative;z-index:1'>
  	<tr><td class=line2 colspan="2"></td></tr>		
    <td class='line' width='470' id='td_title' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='470'>
        <tr> 
          <td width='30' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
          <td width='30' class='title' style='height:51'>����</td>
          <td width='40' class='title'>����</td>		  
          <td width='60' class='title'>��������</td>		  		  
          <td width='40' class='title'>���<br>�ð�</td>		  
		  <td width="50" rowspan="2" class='title'>�����</td>		  		  		  
          <td width='140' class='title'>����׸�</td>		  
          <td width="80" class='title'>�ŷ�����</td>				  
        </tr>
      </table>
	</td>
	<td class='line' width='1740'>
	  <table border="0" cellspacing="1" cellpadding="0" width='1720'>
		<tr>
		  <td width="150" rowspan="2" class='title'>����ó</td>
		  <td width="100" rowspan="2" class='title'>�ݾ�</td>		  
          <td width='60' rowspan="2" class='title'>��ݹ��</td>
          <td colspan="3" class='title'>�Ա�����</td>		  
		  <td width="270" rowspan="2" class='title'>����</td>
          <td width='60' rowspan="2" class='title'>��Ϲ��</td>		  
		  <td width="70" rowspan="2" class='title'>��������</td>		
		  <td width="70" rowspan="2" class='title'>�����ޱ�<br>��ǥó��</td>
		  <td width="70" rowspan="2" class='title'>�����ޱ�</td>		  		  
		  <td width="40" rowspan="2" class='title'>�Ǽ�</td>
          <td colspan="2" class='title'>�������</td>
		  <td colspan="2" class='title'>ī������</td>
		  <td width="150" rowspan="2" class='title'>�����</td>
		</tr>
		<tr>
		  <td width='80' class='title'>����</td>
		  <td width='120' class='title'>���¹�ȣ</td>
		  <td width='100' class='title'>������</td>
		  <td width='80' class='title'>����</td>
		  <td width='120' class='title'>���¹�ȣ</td>
		  <td width='70' class='title'>ī���</td>
		  <td width='130' class='title'>ī���ȣ</td>
		</tr>
	  </table>
	</td>
  </tr>
  <%if(vt_size > 0){%>
  <tr>		
    <td class='line' width='470' id='td_con' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='470'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
        <tr> 
          <td width='30' align='center'>
		  <input type="checkbox" name="ch_cd" value="<%=ht.get("REQSEQ")%>">
		  </td>
          <td width='30' align='center'><%=i+1%></td>		  
          <td width='40' align='center'>
		  <%if(String.valueOf(ht.get("REG_END")).equals("�ϰ�")){%>
		  <%=ht.get("REG_END")%>
		  <%}else{%>
		  <font color=red><%=ht.get("REG_END")%></font>
		  <%}%>
		  </td>		  		  
          <td width='60' align='center'>
		  <%if(String.valueOf(ht.get("P_GUBUN")).equals("01") || String.valueOf(ht.get("P_GUBUN")).equals("06") || String.valueOf(ht.get("P_GUBUN")).equals("02") || String.valueOf(ht.get("P_GUBUN")).equals("04") || String.valueOf(ht.get("P_GUBUN")).equals("11") || String.valueOf(ht.get("P_GUBUN")).equals("12") || String.valueOf(ht.get("P_GUBUN")).equals("13") || String.valueOf(ht.get("P_GUBUN")).equals("21") || String.valueOf(ht.get("P_GUBUN")).equals("31") || String.valueOf(ht.get("P_GUBUN")).equals("37")){//�ڵ������,�Һα�,���·�%>
		    <a href="javascript:parent.view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">����</a>
		  <%}else if(String.valueOf(ht.get("P_GUBUN")).equals("99") && !String.valueOf(ht.get("FILE_CNT")).equals("0")){%>
		    <a href="javascript:parent.view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=String.valueOf(ht.get("FILE_CNT"))%>��</a>		  
		  <%}else if(String.valueOf(ht.get("P_GUBUN")).equals("99") && String.valueOf(ht.get("FILE_CNT")).equals("0")){%>
		    <a href="javascript:parent.view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">���</a>		  
		  <%}else{%>
		  <%	if(String.valueOf(ht.get("FILE_CNT")).equals("0")){%>
		    <a href="javascript:parent.view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">���</a>
		  <%	}else{%>
		    <a href="javascript:parent.view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=String.valueOf(ht.get("FILE_CNT"))%>��</a>
		  <%	}%>
		  <%}%>
		  </td>         		    
          <td width='40' align='center'>
		  <%if(String.valueOf(ht.get("AT_ONCE")).equals("Y")){%>
		  <font color=red>���</font>
		  <%}else{%>
		  ����
		  <%}%>
		  </td>						  
		  <td width='50' align='center'><%=ht.get("REG_NM")%></td>		  		  		      		  		  
  		  <td width='140' align='center'><span title='<%=ht.get("GUBUN_NM")%>'><%=Util.subData(String.valueOf(ht.get("GUBUN_NM")), 6)%></span></td>
          <td width='80' align='center'><a href="javascript:parent.view_pay_ledger('<%=ht.get("REG_END")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("REQSEQ")%>','<%=ht.get("I_SEQ")%>','<%=ht.get("AMT")%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("P_EST_DT")))%></a></td>
        </tr>      
        <%	}%>
				<tr>						
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>					
				    <td class='title'>&nbsp;</td>					
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>					
				</tr>
		
      </table>
	</td>
	<td class='line' width='1740'>
	  <table border="0" cellspacing="1" cellpadding="0" width='1720'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				//�����ڵ� ��������
				if(String.valueOf(ht.get("BANK_ID")).equals("")){
					
				}
				total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
				%>
		<tr>
		  <td width='150' align='center'><span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 10)%></span></td>					
		  <td width='100' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></td>
          <td width='60' align='center'><%=ht.get("WAY_NM")%></td>         
		  <td width='80' align='center'><span title='<%=ht.get("BANK_NM")%>'><%=Util.subData(String.valueOf(ht.get("BANK_NM")), 4)%></span></td>
		  <td width='120' align='center'><%=ht.get("BANK_NO")%></td>
		  <td width='100' align='center'><span title='<%=ht.get("BANK_ACC_NM")%>'><%=Util.subData(String.valueOf(ht.get("BANK_ACC_NM")), 6)%></span></td>		  
		  <td width='270'>&nbsp;<span title='<%=ht.get("P_CONT")%>'><%=Util.subData(String.valueOf(ht.get("P_CONT")), 20)%></td>
          <td width='60' align='center'><%=ht.get("REG_ST_NM")%></td>     		  
          <td width='70' align='center'><%=ht.get("ACCT_CODE")%></td>         		
          <td width='70' align='center'><%=ht.get("ACCT_CODE_ST_NM")%></td>         				  
          <td width='70' align='center'><%=ht.get("R_ACCT_CODE")%></td>         				  		  		  
          <td width='40' align='center'><%=ht.get("I_CNT")%>��</td>         
		  <td width="80" align='center'><span title='<%=ht.get("A_BANK_NM")%>'><%=Util.subData(String.valueOf(ht.get("A_BANK_NM")), 4)%></span></td>
		  <td width="120" align='center'><%=ht.get("A_BANK_NO")%></td>
		  <td width="70" align='center'><span title='<%=ht.get("CARD_NM")%>'><%=Util.subData(String.valueOf(ht.get("CARD_NM")), 4)%></span></td>
		  <td width="130" align='center'><%=ht.get("CARD_NO")%></td>
		  <td width='150' align='center'><%=ht.get("REG_DT")%></td>
		</tr>	
<%		}	%>
				<tr>						
					<td class='title'>�հ�</td>					
					<td class='title' style='text-align:right;'><%=AddUtil.parseDecimalLong(total_amt1)%></td>										
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
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>					
				    <td class='title'>&nbsp;</td>
				</tr>
	  </table>
	</td>
<%	}else{%>                     
    <tr>
	    <td class='line' width='470' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
                </tr>
                </table>
	    </td>
	    <td class='line' width='1740'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		            <td>&nbsp;</td>
		        </tr>
	        </table>
	    </td>
    </tr>
<%	}	%>
</table>
</form>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

