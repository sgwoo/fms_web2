<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, card.*"%>
<%@ page import="acar.pay_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp"%>

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
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int sh_height 	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String p_gubun	= request.getParameter("p_gubun")==null?"":request.getParameter("p_gubun");
	String reqseq 	= request.getParameter("reqseq")==null?"":request.getParameter("reqseq");
	
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	
	//출금원장
	PayMngBean pay 	= pm_db.getPay(reqseq);
	
	//출금원장 세부 항목
	Vector vt =  pm_db.getPayItemList(reqseq);
	int vt_size = vt.size();
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+
				   	"";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	
	
	function view_pay_ledger_doc(reqseq, p_gubun, p_cd1, p_cd2, p_cd3, p_cd4, p_cd5, p_st1, p_st4, i_cnt){
		var w_width  = 850;
		var w_height = 650;
		var url_etc = '';
		if(p_gubun == '01'){
			w_width  = 900;
			w_height = 700;
			window.open("/fms2/car_pur/pur_doc_u.jsp<%=valus%>&mode=view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC2", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
		}else if(p_gubun == '02'){
			w_width  = 900;
			w_height = 700;
			if(p_cd3 == '7'){
						window.open("/fms2/commi/suc_commi_doc_u.jsp<%=valus%>&mode=view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
					}else{
						window.open("/fms2/commi/commi_doc_u.jsp<%=valus%>&mode=view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
					}
		}else if(p_gubun == '04'){
			w_width  = 850;
			w_height = 800;
			if(p_st4=='묶음'){
				var lend_id = p_cd1.substring(0,4);
				var rtn_seq = p_cd1.substring(4);
				window.open("/acar/con_debt/debt_c_bank2.jsp<%=valus%>&mode=view&lend_id="+lend_id+"&rtn_seq="+rtn_seq+"&alt_tm="+p_cd2, "VIEW_PAY_LEDGER_DOC2", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
			}else{
				if(p_cd4 != '') url_etc = '&m_id='+p_cd3+'&l_cd='+p_cd4;
				window.open("/acar/con_debt/debt_c.jsp<%=valus%>&mode=view&c_id="+p_cd1+"&alt_tm="+p_cd2+url_etc, "VIEW_PAY_LEDGER_DOC2", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
			}
		}else if(p_gubun == '11' || p_cd1==p_st1){
			if(p_cd1 == 'null'){
				w_width  = 900;
				w_height = 400;
				window.open("pay_file_list.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");							
			}else{					
				w_width  = 900;
				w_height = 700;			
				if(p_cd5 != '') url_etc = '&rent_mng_id='+p_cd4+'&rent_l_cd='+p_cd5;			
				window.open("/acar/cus_reg/serv_reg.jsp<%=valus%>&mode=view&car_mng_id="+p_cd1+"&serv_id="+p_cd2+url_etc, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
			}
		}else if(p_gubun == '21'){
			w_width  = 1000;
			w_height = 800;
			window.open("/acar/fine_mng/fine_mng_frame.jsp<%=valus%>&mode=view&car_mng_id="+p_cd1+"&seq_no="+p_cd2+"&rent_mng_id="+p_cd3+"&rent_l_cd="+p_cd4, "VIEW_PAY_LEDGER_DOC2", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
		}else if(p_gubun == '31'){
			w_width  = 1000;
			w_height = 800;
			window.open("/fms2/cls_cont/lc_cls_u3.jsp<%=valus%>&mode=view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC2", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
		}else if(p_gubun == '35'){
			w_width  = 1100;
			w_height = 600;
			window.open("/fms2/lc_rent/lc_c_c_suc_commi.jsp<%=valus%>&mode=pay_view&rent_mng_id="+p_cd1+"&rent_l_cd="+p_cd2, "VIEW_PAY_LEDGER_DOC", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
		}else{		
			window.open("pay_file_list.jsp<%=valus%>&p_gubun="+p_gubun+"&reqseq="+reqseq, "VIEW_PAY_LEDGER_DOC2", "left=10, top=10, width="+w_width+", height="+w_height+", scrollbars=yes");		
		}
	}		
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
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
  <input type='hidden' name='from_page' value='<%=from_page%>'>  
  <input type='hidden' name='reqseq' 	value='<%=reqseq%>'>    
  <input type='hidden' name='bank_nm' value=''>      
  <input type='hidden' name='ven_nm_cd' value=''>        
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 집금관리 > <span class=style5>
						출금원장 세부 리스트</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
      <td class=h></td>
    </tr>
	<tr>
	  <td align="right">&nbsp;</td>
	<tr> 	
    <tr>
        <td class=line2></td>
    </tr>     
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>            
            <td width="10%" class=title>거래일자</td>
            <td width="10%" >&nbsp;			  
              <%=AddUtil.ChangeDate2(pay.getP_est_dt())%></td>
            <td width="10%" class=title>금액</td>
            <td width="10%" >&nbsp;			  
              <%=AddUtil.parseDecimalLong(pay.getAmt())%>원</td>
            <td width="10%" class=title>법인카드</td>
            <td style="font-size:13px" >&nbsp;			  
           <b><%=pay.getCard_nm()%> <%=pay.getCard_no()%>
              
              <%
              		if(!pay.getCard_no().equals("")){
              			//카드정보
          				CardBean c_bean = CardDb.getCard(pay.getCard_no());              			
          	  %>
          	  &nbsp;
          	  유효기간(월/년) : <%=AddUtil.ChangeDate7(c_bean.getCard_edate())%>
          	  
          	  <%	} %>
          	  </b>
            </td>
          </tr>
		</table>
	  </td>
	</tr> 		
	<tr>
	  <td>&nbsp;</td>
	</tr>  		
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="5%" class=title>연번</td>
            <td width="15%" class=title>계출번호</td>			
            <td width="10%" class=title>금액</td>
            <td width="70%" class=title>적요</td>									
          </tr>
          <%
		 	for(int i = 0 ; i < vt_size ; i++){
				PayMngBean pm = (PayMngBean)vt.elementAt(i);%>			  
          <tr>
            <td align="center"><%=i+1%></td>
            <td align="center">
		    	<%if(p_gubun.equals("07")){%>
		    		<%=pm.getP_cd1()%>
		    	<%}else{ %>
		    		<%=pm.getP_cd3()%>
		    	<%} %>
			</td>															
            <td align="right"><%=AddUtil.parseDecimalLong(pm.getI_amt())%>원</td>
            <td>&nbsp;<%=pm.getP_cont()%></td>						
          </tr>
	      <%}%>		
		</table>
	  </td>
	</tr> 				
    <tr>
	    <td align='center'>
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
	    </td>
	</tr>	
	<tr>
	    <td align="right">&nbsp;</td>
	</tr>		
  </table>
</form>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

