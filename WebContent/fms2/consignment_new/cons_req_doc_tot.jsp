<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.cus0601.*" %>
<%@ page import="acar.util.*, acar.consignment.*, acar.user_mng.*, acar.doc_settle.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
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
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String req_code	= request.getParameter("req_code")==null?"":request.getParameter("req_code");
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String req_dt 	= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String pay_dt 	= request.getParameter("pay_dt")==null?"":request.getParameter("pay_dt");
	String br_id2 	= request.getParameter("br_id2")==null?"":request.getParameter("br_id2");
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	if(doc_no.equals("")){
		doc = d_db.getDocSettleCommi("3", req_code);
		doc_no = doc.getDoc_no();
	}
	
	//out.println(doc_no);
	//out.println(pay_dt);
	
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	Vector vt = new Vector();
	if(doc_no.equals("")){
		vt = cs_db.getConsignmentNotPayOffList(off_id, req_dt, br_id2);
	}else{
		vt = cs_db.getConsignmentReqDocListDrv(req_code, pay_dt);
		if(vt.size()>0){
			for(int i = 0 ; i < 1 ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
			}
		}
	}
	int vt_size = vt.size();
	
	Cus0601_Database c61_db = Cus0601_Database.getInstance();
	c61_soBn = c61_db.getServOff(off_id);
	
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;	//세차수수료(20190517)
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+
					"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&from_page="+from_page+"&mode="+mode+"&off_id="+off_id+"&req_dt="+req_dt+"";
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:onprint();">

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
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
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name='off_id' 	value='<%=off_id%>'>
  <input type='hidden' name='req_code' 	value='<%=req_code%>'>  
  <input type='hidden' name='req_dt' 	value='<%=req_dt%>'>
  <input type='hidden' name='br_id2' 	value='<%=br_id2%>'>  
  <input type='hidden' name='doc_bit' 	value='<%=doc_bit%>'>
  <input type='hidden' name='doc_no' 	value='<%=doc_no%>'>
  <input type='hidden' name='size' 		value='<%=vt_size%>'>
  <input type='hidden' name='off_nm' 	value='<%=c61_soBn.getOff_nm()%>'>
  <input type='hidden' name='user_dt1' 		value='<%=doc.getUser_dt1()%>'>
  <input type='hidden' name='msg_send_bit' 	value=''>
  <input type='hidden' name='d_cons_no' 	value=''>

  <table border="0" cellspacing="0" cellpadding="0" width=1020>
    <tr>
      <td>&lt; 탁송기사별 탁송료 청구 리스트 &gt; </td>
    </tr>  
    <tr>
      <td>&nbsp;<%if(mode.equals("doc_settle")){%><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a><%}%></td>
    </tr>  
	<tr>
	  <td>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width="800" class=line>
			  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
			  <tr><td class=line2></td></tr>
                <tr>
                  <td width="10%" align='center'>탁송업체</td>		  
                  <td width="23%" align='center'><%=c61_soBn.getOff_nm()%></td>
                  <td width="10%" align='center'>거래은행</td>
                  <td width="23%" align='center'><%=c61_soBn.getBank()%></td>
                  <td width="10%" align='center'>계좌번호</td>
                  <td align='center'><%=c61_soBn.getAcc_no()%></td>
                </tr>
                <tr>
		          <td align='center'>청구일자</td>
                  <td align='center'><%=AddUtil.ChangeDate2(req_dt)%></td>
                  <td align='center'>총건수</td>
                  <td align='center'><%=vt_size%>건</td>
                  <td align='center'>총청구금액</td>
                  <td align='center'><input type='text' name="req_amt" value='' size='10' class='whitenum' readonly>원</td>
                </tr>
              </table>
			</td>
			<td width="160">&nbsp;</td>
          </tr>
        </table>		  
	  </td>	
	</tr>
<!--	
    <tr>
      <td class=line>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width="10%" align='center'>탁송업체</td>		  
            <td>&nbsp;<%=c61_soBn.getOff_nm()%></td>
          </tr>
      </table></td>
    </tr>
-->	
    <tr>
      <td>&nbsp;</td>
    </tr>  
	<tr>
	  <td class=line>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr><td class=line2></td></tr>
		  <tr valign="middle" align="center"> 
		    <td style="font-size:8pt" width='25' rowspan="2" align='center'>연번</td>
		    <td style="font-size:8pt" width="60" rowspan="2" align='center'>운전자</td>
		    <td style="font-size:8pt" colspan="6" align='center'>청구금액</td>
	      </tr>
		  <tr valign="middle" align="center">
		    <td style="font-size:8pt" width='60' align='center'>탁송료</td>
		    <td style="font-size:8pt" width='50' align='center'>유류비</td>
		    <td style="font-size:8pt" width='45' align='center'>세차비</td>
		    <td style="font-size:8pt" width='45' align='center'>세차수수료</td>
		    <td style="font-size:8pt" width='50' align='center'>기타금액</td>
		    <td style="font-size:8pt" width='60' align='center'>소계</td>
		  </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String tint_dt = String.valueOf(ht.get("FROM_DT"));
				if(tint_dt.length() >= 8){
					tint_dt = tint_dt.substring(0,8);
				}
				if(tint_dt.length() == 0){
					tint_dt = String.valueOf(ht.get("REG_DT"));
				}%>
		  <tr> 
		    <td style="font-size:8pt" align='center'><%=i+1%></td>
		    <td style="font-size:8pt" align='center'><%=ht.get("DRIVER_NM")%></td>						
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_AMT")))%></td>
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OIL_AMT")))%></td>			
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_AMT")))%></td>
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_FEE")))%></td>
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OTHER_AMT")))%></td>
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>
		    
		    
			</td>			
		  </tr>
  <%		total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CONS_AMT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("WASH_AMT")));
			total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("OTHER_AMT")));
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT")));
			//total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("HIPASS_AMT")));
			total_amt8 	= total_amt8 + AddUtil.parseLong(String.valueOf(ht.get("WASH_FEE")));
			
		  }%>
				<tr>
					<td colspan="2" align='center'>합계</td>
					<td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt1)%></td>
					<td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt2)%></td>					
					<td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt3)%></td>
					<td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt8)%></td>															
				    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt4)%></td>
				    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt5)%></td>
				</tr>		  
	    </table>
	  </td>
	</tr>
	<tr>
		<td align="right">
		  <a href="javascript:print()"><img src=/acar/images/center/button_print.gif border=0 align=absmiddle></a><font color=#CCCCCC>&nbsp;(※인쇄TIP : A4, 가로방향)</font>&nbsp;&nbsp;
		  <a href="javascript:window.close();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
		</td>	
	</tr>	
	<tr>
		<td>&nbsp;</td>	
	</tr>	
  </table>
  <input type='hidden' name='cons_amt' 	value='<%=total_amt1%>'>
  <input type='hidden' name='oil_amt' 	value='<%=total_amt2%>'>
  <input type='hidden' name='wash_amt' 	value='<%=total_amt3%>'>
  <input type='hidden' name='other_amt' value='<%=total_amt4%>'>
  <input type='hidden' name='tot_amt' 	value='<%=total_amt5%>'>        
  <input type='hidden' name='hipass_amt' value='<%=total_amt6%>'>          
</form>  
<script language='javascript'>
<!--
	document.form1.req_amt.value = '<%=Util.parseDecimal(total_amt5)%>';
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
<script language="JavaScript" type="text/JavaScript">
function onprint(){
factory.printing.header 		= ""; //폐이지상단 인쇄
factory.printing.footer 		= ""; //폐이지하단 인쇄
factory.printing.portrait 		= false; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin 	= 10; //좌측여백   
factory.printing.rightMargin 	= 10; //우측여백
factory.printing.topMargin 		= 10; //상단여백    
factory.printing.bottomMargin 	= 10; //하단여백
//factory.printing.Print(false, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>
