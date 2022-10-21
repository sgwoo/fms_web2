<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.pay_mng.*, acar.bill_mng.*"%>
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
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+
					"&st_dt="+st_dt+"&end_dt="+end_dt+
				   	"&sh_height="+sh_height+"";
	
	
	String reqseq 	= request.getParameter("reqseq")==null?"":request.getParameter("reqseq");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	//출금원장
	PayMngBean pay 	= pm_db.getPay(reqseq);
			
	

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
	
	//스캔등록
	function scan_file(file_st){
		window.open("reg_scan.jsp<%=valus%>&reqseq=<%=reqseq%>&from_page=/fms2/pay_mng/pay_file_list.jsp&file_st="+file_st, "SCAN", "left=300, top=300, width=620, height=200, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	//스캔등록
	function scan_file_all(file_st){
		window.open("reg_scan_all.jsp<%=valus%>&reqseq=<%=reqseq%>&from_page=/fms2/pay_mng/pay_file_list.jsp&file_st="+file_st, "SCAN", "left=300, top=300, width=820, height=500, scrollbars=yes, status=yes, resizable=yes");
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
  <input type='hidden' name='mode' value='pay_file_list.jsp'>          
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 집금관리 > <span class=style5>
						출금원장 증빙서류 파일 리스트</span></span></td>
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
            <td class=title width=15%>거래일자</td>
            <td>&nbsp;<%=AddUtil.ChangeDate2(pay.getP_est_dt())%></td>
          </tr>
		</table>
	  </td>
	</tr>	 	
	<tr>
	  <td>▣ 출금요청내역</td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr>
            <td width="15%" class=title>출금방식</td>
            <td>&nbsp;
			  	<input type='radio' name="p_way" value='1' <%if(pay.getP_way().equals("1"))%>checked<%%>>
				현금지출
			  	<input type='radio' name="p_way" value='5' <%if(pay.getP_way().equals("5"))%>checked<%%>>
				계좌이체
				<input type='radio' name="p_way" value='4' <%if(pay.getP_way().equals("4"))%>checked<%%>>
				자동이체
				<input type='radio' name="p_way" value='2' <%if(pay.getP_way().equals("2"))%>checked<%%>>
				선불카드
				<input type='radio' name="p_way" value='3' <%if(pay.getP_way().equals("3"))%>checked<%%>>
				후불카드
				<input type='radio' name="p_way" value='7' <%if(pay.getP_way().equals("7"))%>checked<%%>>
				카드할부
				</td>
          </tr>
          <tr>
            <td class=title>금액</td>
            <td>&nbsp; <%=AddUtil.parseDecimalLong(pay.getAmt())%>원 </td>
          </tr>
          <tr>				
            <td class=title>지출처</td>
            <td>&nbsp;[
                <%if(pay.getOff_st().equals("cpt_cd")){		%>
                금융사
                <%}%>
                <%if(pay.getOff_st().equals("com_code")){	%>
                자동차사
                <%}%>
                <%if(pay.getOff_st().equals("ins_com_id")){	%>
                보험사
                <%}%>
                <%if(pay.getOff_st().equals("car_off_id")){	%>
                영업소
                <%}%>
                <%if(pay.getOff_st().equals("emp_id")){		%>
                영업사원
                <%}%>
                <%if(pay.getOff_st().equals("off_id")){		%>
                협력업체
                <%}%>
                <%if(pay.getOff_st().equals("gov_id")){		%>
                정부기관
                <%}%>
                <%if(pay.getOff_st().equals("br_id")){		%>
                아마존카
                <%}%>
                <%if(pay.getOff_st().equals("user_id")){		%>
                아마존카직원
                <%}%>
                <%if(pay.getOff_st().equals("other")){		%>
                기타
                <%}%>
                ]&nbsp;<%=pay.getOff_nm()%> &nbsp; <img src=/acar/images/center/arrow.gif align=absmiddle> 코드 : <%=pay.getOff_id()%> 
                &nbsp;&nbsp;&nbsp;&nbsp;
			  <%//네오엠코드 처리
				if(!pay.getVen_code().equals("") && pay.getS_idno().equals("")){
					Hashtable vendor = neoe_db.getVendorCase(pay.getVen_code());
					pay.setS_idno(String.valueOf(vendor.get("S_IDNO")));
				}%>
                
                (<%=pay.getS_idno()%>)	
                </td>
          </tr>
          <%
                   	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                   	
			String content_code = "PAY";
			String content_seq  = reqseq; 
			
			Vector attach_vt = attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
			int attach_vt_size = attach_vt.size();   
			
			if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);               
          %>
          <tr>
            <%if(j==0){%><td rowspan="5" class=title>증빙서류<%if(attach_vt_size<4){%><br>&nbsp;<br><a href ="javascript:scan_file_all('')" title='스캔일괄등록'><img src=/acar/images/center/button_reg_scan_ig.gif align=absmiddle border=0></a><%}%></td><%}%>
            <td>&nbsp;
                <a href="javascript:openPopF('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
                &nbsp;&nbsp;
                <a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
 	    </td>
         </tr>
         <%			}%>
         <%		}%>
         
         <%		for(int i=attach_vt_size;i < 5;i++){%>
          <tr>         
            <%if(attach_vt_size==0 && i==0){%><td rowspan="5" class=title>증빙서류<br>&nbsp;<br><a href ="javascript:scan_file_all('')" title='스캔일괄등록'><img src=/acar/images/center/button_reg_scan_ig.gif align=absmiddle border=0></a></td><%}%>   
            <td>&nbsp;
                <a href="javascript:scan_file('')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
 	    </td>
         </tr>                  
         <%		}%>
         	  
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

