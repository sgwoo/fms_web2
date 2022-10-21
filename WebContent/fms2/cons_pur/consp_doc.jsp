<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
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
	String doc_bit 	= request.getParameter("doc_bit")==null?"":request.getParameter("doc_bit");
	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String dlv_ym 	= request.getParameter("dlv_ym")==null?"":request.getParameter("dlv_ym");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	if(doc_no.equals("")){
		doc = d_db.getDocSettleCommi("34", req_code);
		doc_no = doc.getDoc_no();
	}
	
	
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	Vector vt = new Vector();
	if(doc_no.equals("")){
		vt = cs_db.getConsignmentPurNotPayOffList(off_id, dlv_ym);
	}else{
		vt = cs_db.getConsignmentPurReqDocList2(req_code, pay_dt);
		if(vt.size()>0){
			for(int i = 0 ; i < 1 ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				off_id = String.valueOf(ht.get("OFF_ID"));
				req_dt = String.valueOf(ht.get("REQ_DT"));				
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
	
	if(req_dt.equals("null") || req_dt.equals("")){
		req_dt = AddUtil.getDate();
	}
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+
					"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&from_page="+from_page+"&mode="+mode+"&off_id="+off_id+"&req_dt="+req_dt+"";
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//리스트
	function list(){
		var fm = document.form1;		
		if(fm.mode.value == 'doc_settle'){
			fm.action = '/fms2/doc_settle/doc_settle_frame.jsp';
		}else{
			fm.action = 'consp_doc_frame.jsp';
		}			
		fm.target = 'd_content';
		fm.submit();
	}	
	
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		
		if(confirm('결재하시겠습니까?')){	
			fm.action='consp_doc_sanction.jsp';		
			fm.target='i_no';
			fm.submit();
		}									
	}
	
	
	//네오엠전표조회
	function autodocu_reg(){
		var fm = document.form1;
		
		
		if(fm.req_code.value == '')	{ alert('청구코드가 없습니다. 확인하십시오.'); return; }		
		if(fm.req_dt.value == '')	{ alert('청구일자가 없습니다. 확인하십시오.'); return; }				
		
		if(confirm('미지급금전표를 발행하시겠습니까?')){
			fm.action='consp_doc_autodocu_reg.jsp';		
			fm.target = 'i_no';
			fm.submit();		
		}
	}		
	
	function view_cons(cons_no, rent_mng_id, rent_l_cd){
		var fm = document.form1;
		fm.d_cons_no.value 	= cons_no;		
		fm.rent_mng_id.value 	= rent_mng_id;		
		fm.rent_l_cd.value 	= rent_l_cd;		
		fm.action = 'cons_pur_c.jsp';				
		fm.target = 'd_content';
		fm.submit();
	}	

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="http://www.amazoncar.co.kr/smsx.cab#Version=6,3,439,30">
</object>
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
  <input type='hidden' name='doc_bit' 	value='<%=doc_bit%>'>
  <input type='hidden' name='doc_no' 	value='<%=doc_no%>'>
  <input type='hidden' name='size' 		value='<%=vt_size%>'>
  <input type='hidden' name='off_nm' 		value='<%=c61_soBn.getOff_nm()%>'>
  <input type='hidden' name='user_dt1' 		value='<%=doc.getUser_dt1()%>'>
  <input type='hidden' name='msg_send_bit' 	value=''>
  <input type='hidden' name='d_cons_no' 	value=''>  
  <input type='hidden' name='rent_mng_id' 	value=''>
  <input type='hidden' name='rent_l_cd' 	value=''>


<table border="0" cellspacing="0" cellpadding="0" width=620>
    <tr>
        <td>&lt; 탁송료 청구 리스트 &gt; </td>
    </tr>  
    <tr>
        <td>&nbsp;<%if(mode.equals("doc_settle")){%><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a><%}%></td>
    </tr>  
    <tr>
	<td class=line>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td class=line2></td>
		</tr>	    
                <tr valign="middle" align="center"> 
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
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>  
    <tr>
	<td class=line>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td class=line2></td>
		</tr>
		<tr valign="middle" align="center"> 
		    <td width='40' align='center'>연번</td>
		    <td width='80' align='center'>출고일자</td>			
		    <td width='100' align='center' >제조사</td>		    
		    <td width='130' align='center' >계출번호</td>		    
		    <td width='80' align='center'>출고사무소</td>
		    <td width='90' align='center'>탁송지점</td>
		    <td width='100' align='center'>청구금액</td>
	        </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);				
%>
	        <tr> 
		    <td align='center'><%=i+1%><input type='hidden' name='cons_no' value='<%=ht.get("CONS_NO")%>'></td>
		    <td align='center'><%=ht.get("DLV_DT")%><%if(String.valueOf(ht.get("DLV_DT")).equals("")){%><%=ht.get("UDT_DT")%><%}%></td>						
		    <td align='center'><%=ht.get("CAR_COMP_NM")%></td>
		    <td align='center'><a href="javascript:view_cons('<%=ht.get("CONS_NO")%>', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>');">
		    <%if(!String.valueOf(ht.get("RETURN_DT")).equals("") && !String.valueOf(ht.get("RT_COM_CON_NO")).equals("")){%>
		    (반품)<%=ht.get("RT_COM_CON_NO")%>
		    <%}else{ %>
		    <%=ht.get("RPT_NO")%>
		    <%} %>
		    </a></td>
		    <td align='center'><%=ht.get("DLV_EXT")%></td>			
		    <td align='center'><%=ht.get("UDT_ST_NM")%></td>
		    <td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_AMT1")))%></td>
	        </tr>
<%			total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("CONS_AMT1")));			
		}
%>
	        <tr>
		    <td colspan='6'>합계</td>
		    <td align='right'><%=Util.parseDecimal(total_amt1)%></td>
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
    <%if(!nm_db.getWorkAuthUser("아마존카이외",user_id)){%>	
    <tr>
	<td>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width="230" class=line>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			    <tr><td class=line2></td></tr>
                            <tr valign="middle" align="center">
                                <td width='30' rowspan="2" align='center'>결<br>재</td>                                
                                <td width='100' align='center'>탁송관리자</td>				
                                <td width='100' align='center' >총무팀장</td>
                            </tr>
                            <tr>                                				
                                <td align='center'><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%><%if(doc.getUser_dt1().equals("")){%><a href="javascript:doc_sanction('1')"><img src="/acar/images/center/button_in_gian.gif" align="absmiddle" border="0"></a><br>&nbsp;<%}else{%><%if(doc.getUser_dt2().equals("")){%><!--<%if(doc.getUser_id1().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%><br><a href="javascript:msg_send('2')">결재요청</a><%}%>--><%}%><%}%></td>
                                <td align='center'><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%><%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("")){%><%if(doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("차량대금팀장결재대행",user_id)){%><a href="javascript:doc_sanction('2')"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a><br>&nbsp;<%}%><%}%></td>								
                            </tr>
                        </table>
		    </td>
		    <td width="390">&nbsp;</td>
          	</tr>
            </table>		  
	</td>	
    </tr>    
    <!--미지급금전표발행-->
    
    <%		if(!doc.getUser_id1().equals("") && ( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사고객지원팀출납",user_id) || nm_db.getWorkAuthUser("탁송관리자",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) ) ){%>
    <tr>
	<td>&nbsp;</td>	
    </tr>
    <tr>
	<td><hr></td>	
    </tr>
    <tr>
        <td>&lt; 탁송료 미지급금 자동전표 &gt; </td>
    </tr>  
    <tr>
	<td>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width="400" class=line>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			    <tr><td class=line2></td></tr>
                            <tr>
                                <td width="30%" align='center'>전표일자</td>
                                <td width="70%">&nbsp;<input type='text' name='autodocu_dt' value='<%=AddUtil.ChangeDate2(req_dt)%>' maxlength='11' size='11' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                            </tr>
                            <tr>
                                <td width="30%" align='center'>금액</td>
                                <td width="70%">
				    &nbsp;공급가 : <input type='text' name='autodocu_s_amt' value='' maxlength='15' size='10' class='num' >
				    &nbsp;부가세 : <input type='text' name='autodocu_v_amt' value='' maxlength='15' size='10' class='num' >				  
				</td>
                            </tr>				
                        </table>
		    </td>
		    <td width="220">&nbsp;<a href="javascript:autodocu_reg()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_jpbh_mgg.gif border=0 align=absmiddle></a></td>
                </tr>
            </table>		  
	</td>	
    </tr>		
    <tr>
	<td>※ 네오엠에 미지급금 전표가 미발행일때 처리하세요. 출금원장에 자동등록됩니다.</td>	
    </tr>
    <%		}%>
    
    <%}%>	
  </table>
  <input type='hidden' name='cons_amt' 	value='<%=total_amt1%>'>
</form>  
<script language='javascript'>
<!--
	document.form1.req_amt.value = '<%=Util.parseDecimal(total_amt1)%>';
	
	<%if(!nm_db.getWorkAuthUser("아마존카이외",user_id)){%>	
	<%		if(!doc.getUser_id1().equals("") && ( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사고객지원팀출납",user_id) || nm_db.getWorkAuthUser("탁송관리자",user_id) || nm_db.getWorkAuthUser("출고관리자",user_id) ) ){%>
	document.form1.autodocu_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(document.form1.req_amt.value))));
	document.form1.autodocu_v_amt.value = parseDecimal(toInt(parseDigit(document.form1.req_amt.value)) - toInt(parseDigit(document.form1.autodocu_s_amt.value)));			
	//document.form1.autodocu_s_amt.value = document.form1.req_amt.value;
	//document.form1.autodocu_v_amt.value = parseDecimal(toInt(parseDigit(document.form1.req_amt.value)) * 0.1 );			
	<%		}%>	
        <%}%>
	
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
factory.printing.leftMargin 		= 10; //좌측여백   
factory.printing.rightMargin 		= 10; //우측여백
factory.printing.topMargin 		= 10; //상단여백    
factory.printing.bottomMargin 		= 10; //하단여백
//factory.printing.Print(false, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>
