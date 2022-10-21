<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.user_mng.*"%>
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
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt =  pm_db.getPayRList(s_kd, t_wd, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2	= 0;
	long total_amt3	= 0;
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
  <input type='hidden' name='from_page' value='/fms2/pay_mng/pay_r_frame.jsp'>  
<table border="0" cellspacing="0" cellpadding="0" width='2020'>
  <tr id='tr_title' style='position:relative;z-index:1'>
  	<tr><td class=line2 colspan="2"></td></tr>		
    <td class='line' width='500' id='td_title' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='500'>
        <tr> 
          <td width='30' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
          <td width='30' class='title' style='height:51'>����</td>    
		  <td width="60" class='title'>�����</td>		  
          <td width='80' class='title'>��û����</td>		  
          <td width='200' class='title'>����ó</td>
          <td width='100' class='title'>�ݾ�</td>		
        </tr>
      </table>
	</td>
	<td class='line' width='1520'>
	  <table border="0" cellspacing="1" cellpadding="0" width='1520'>
		<tr>
		  <td colspan="2" class='title'>�������</td>		
		  <td colspan="4" class='title'>�Ա�����</td>
		  <td colspan="2" class='title'>�۱ݰ��</td>
		  <td width="40" rowspan="2" class='title'>����</td>		    		  		  
		  <td colspan="7" class='title'>���࿬��</td>		    		  
		  <td width="30" rowspan="2" class='title'>-</td>		    		  		  		  
		  </tr>
		<tr>
		  <td width='100' class='title'>������</td>
		  <td width='120' class='title'>���¹�ȣ</td>
		  
		  <td width='100' class='title'>������</td>
		  <td width='120' class='title'>���¹�ȣ</td>
		  <td width='150' class='title'>������</td>		  
		  <td width='60' class='title'>����</td>		  
		  
		  <td width="80" class='title'>�۱�����</td>
		  <td width="80" class='title'>�۱ݼ�����</td>		  
		  <td width="80" class='title'>��ü������</td>		  
		  <td width="80" class='title'>��ü���ܾ�</td>		  
		  <td width="80" class='title'>��ü�ð�</td>		  
		  <td width="80" class='title'>�����ڵ�</td>		  		  		  		  
		  <td width="80" class='title'>�Ҵɻ���</td>		  		  		  		  		  
		  <td width="120" class='title'>������ȸ���</td>		  		  		  		  
		  <td width="80" class='title'>��ġ����</td>		  		  		  		  		  
		</tr>
	  </table>
	</td>
  </tr>
  <%if(vt_size > 0){%>
  <tr>		
    <td class='line' width='500' id='td_con' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='500'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
				%>
        <tr> 
          <td width='30' align='center'>
		  <%if(!String.valueOf(ht.get("ACT_BIT_NM")).equals("����")){%>
		  <%	if(AddUtil.parseInt(String.valueOf(ht.get("ACT_DT"))) > 20100927 && String.valueOf(ht.get("I_TRAN_DT")).equals("")){//�λ��̵��ũ%>		  
		  <input type="checkbox" name="ch_cd" value="<%=ht.get("ACTSEQ")%>">
		  <%	}else if(AddUtil.parseInt(String.valueOf(ht.get("ACT_DT"))) <= 20100927 && String.valueOf(ht.get("TRAN_DT")).equals("")){//������Ʈ��%>		  
		  <input type="checkbox" name="ch_cd" value="<%=ht.get("ACTSEQ")%>">		  
		  <%	}%>
		  <%}%>	
		  </td>		  
          <td width='30' align='center'><%=i+1%></td>		  
		  <td width='60' align='center'><%=ht.get("REG_NM")%></td>		  		  		  
          <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ACT_DT")))%></td>         		  
          <td width='200'>&nbsp;
                  [<%=ht.get("PAY_REG_NM")%>]
		  <%if(String.valueOf(ht.get("ACT_BIT_NM")).equals("���") || nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("ȸ�����",user_id)){%>
		  <a href="javascript:parent.view_pay_act('<%=ht.get("ACTSEQ")%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 10)%></span></a>
		  <%}else{%>
		  <span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 11)%></span>
		  <%}%>		  
		  </td>         		  		  		  
  		  <td width='100' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></td>
        </tr>      
        <%	}%>
				<tr>						
				    <td class='title' colspan='5'>�հ�</td>
				    <td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt1)%></td>
				</tr>
      </table>
	</td>
	<td class='line' width='1520'>
	  <table border="0" cellspacing="1" cellpadding="0" width='1520'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("COMMI")));
				total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("TRAN_FEE")));
				%>
		<tr>
		  <td width='100' align='center'><span title='<%=ht.get("A_BANK_NM")%>'><%=Util.subData(String.valueOf(ht.get("A_BANK_NM")), 6)%></span></td>
		  <td width='120' align='center'><%=ht.get("A_BANK_NO")%></td>
		  <td width='100' align='center'><span title='<%=ht.get("BANK_NM")%>'><%=Util.subData(String.valueOf(ht.get("BANK_NM")), 6)%></span></td>
		  <td width='120' align='center'><%=ht.get("BANK_NO")%></td>
		  <td width='150' align='center'><span title='<%=ht.get("BANK_ACC_NM")%>'><%=Util.subData(String.valueOf(ht.get("BANK_ACC_NM")), 10)%></span></td>		  
		  <td width='60' align='center'><a href="javascript:parent.reg_bank_acc_st('<%=ht.get("ACTSEQ")%>','<%=ht.get("BANK_NO")%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><%=ht.get("CONF_ST_NM")%></a></td>
		  <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("R_ACT_DT")))%></td>					
		  <td width='80' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("COMMI")))%></td>
		  <td width='40' align='center'><%=ht.get("ACT_BIT_NM")%></td>
		  <%if(AddUtil.parseInt(String.valueOf(ht.get("ACT_DT"))) > 20100927){//�λ��̵��ũ%>
		  <td width='80' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("I_TRAN_FEE")))%></td>		  
		  <td width='80' align='right'><%if(!String.valueOf(ht.get("TRAN_STATUS")).equals("") && !String.valueOf(ht.get("TRAN_STATUS")).equals("02")){%><a href="javascript:parent.pay_ebank_del('<%=ht.get("ACTSEQ")%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_cancel_yd.gif" align="absmiddle" border="0"></a><%}%></td>		  
		  <td width='80' align='center'><%=ht.get("TR_TIME")%></td>		  
		  <td width='80' align='center'><%=ht.get("TRAN_STATUS")%></td>		  
		  <td width='80' align='center'><%=ht.get("TRAN_STATUS_NM")%></td>		  		  		  		  		  		  		  		  
		  <%}else{//������Ʈ��%>
		  <td width='80' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("TRAN_FEE")))%></td>		  
		  <td width='80' align='right'><%=Util.parseDecimal(String.valueOf(ht.get("TRAN_REMAIN")))%></td>		  
		  <td width='80' align='center'><%=ht.get("TRAN_TM")%><%if(!String.valueOf(ht.get("ERR_CODE")).equals("") && !String.valueOf(ht.get("ERR_CODE")).equals("005")){%><a href="javascript:parent.pay_ebank_del('<%=ht.get("ACTSEQ")%>')" onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_in_cancel_yd.gif" align="absmiddle" border="0"></a><%}%></td>		  
		  <td width='80' align='center'><%=ht.get("ERR_CODE")%></td>		  
		  <td width='80' align='center'><%=ht.get("ERR_REASON")%></td>		  		  		  		  		  		  		  
		  <%}%>
		  <td width='120' align='center'><%=ht.get("RESULT_NM")%></td>		  
		  <td width='80' align='center'><%=ht.get("MATCH_YN")%></td>		  		  		  		  		  		  		  
		  <td width='30' align='center'> </td>		  
		</tr>	
<%		}	%>
				<tr>						
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>					
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt2)%></td>
				    <td class='title'>&nbsp;</td>
				    <td class='title' style='text-align:right'><%=AddUtil.parseDecimalLong(total_amt3)%></td>
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
	    <td class='line' width='500' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
                </tr>
                </table>
	    </td>
	    <td class='line' width='1520'>
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

