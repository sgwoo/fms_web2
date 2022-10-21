<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.cus0601.*" %>
<%@ page import="acar.util.*, acar.consignment.*, acar.user_mng.*, acar.doc_settle.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/off/cookies.jsp" %> 

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
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
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
		vt = cs_db.getConsignmentReqDocList2(req_code, pay_dt);
		if(vt.size()>0){
			for(int i = 0 ; i < 1 ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				off_id = String.valueOf(ht.get("OFF_ID"));
				req_dt = String.valueOf(ht.get("REQ_DT"));
				br_id2 = user_bean.getBr_id();
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
	
	long total_amt11	= 0;
	long total_amt12	= 0;
	long total_amt13	= 0;
	
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
	var popObj = null;
	
	//리스트
	function list(){
		var fm = document.form1;		
		if(fm.mode.value == 'doc_settle'){
			fm.action = '/fms2/doc_settle/doc_settle_frame.jsp';
		}else{
			fm.action = 'cons_req_doc_frame.jsp';
		}			
		fm.target = 'd_content';
		fm.submit();
	}	

	function view_cons(cons_no, seq){
		var width 	= 800;
		var height 	= 700;		
		window.open("cons_reg_print.jsp?cons_no="+cons_no+"&seq="+seq+"&step=3", "Print", "left=10, top=10, width="+width+", height="+height+", scrollbars=yes, status=yes, resizable=yes");		
	}
	
	function view_cons2(cons_no, seq){
		var fm = document.form1;		
		fm.action='cons_reg_step4.jsp?cons_no='+cons_no;		
		fm.target='d_content';
		fm.submit();
	}	
	
	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		
		if(confirm('결재하시겠습니까?')){	
			fm.action='cons_req_doc_sanction.jsp';		
//			fm.target='i_no';
			fm.submit();
		}									
	}
	
	function msg_send(msg_send_bit){
		var fm = document.form1;
		
		if(confirm('메시지를 재전송하시겠습니까?')){	
			fm.msg_send_bit.value = msg_send_bit;		
			fm.action='cons_req_doc_sanction.jsp';		
//			fm.target='i_no';
			fm.submit();
		}						
	}	
	
	//네오엠전표조회
	function autodocu_reg(){
		var fm = document.form1;
		
		if(fm.req_code.value == '')	{ alert('청구코드가 없습니다. 확인하십시오.'); return; }		
		if(fm.req_dt.value == '')	{ alert('청구일자가 없습니다. 확인하십시오.'); return; }				
		
		if(confirm('미지급금전표를 발행하시겠습니까?')){
			fm.action='cons_req_doc_autodocu_reg.jsp';		
			fm.target = 'i_no';
//			fm.target = '_blank';
			fm.submit();		
		}
	}		
	
	function doc_cancel(d_cons_no){
		var fm = document.form1;
		fm.d_cons_no.value = d_cons_no;
				
		if(confirm('취소하시겠습니까?')){	
			fm.action='cons_req_doc_cancel.jsp';		
			fm.target='i_no';
			fm.submit();
		}
		
	}	
	
	function cons_doc_tot(req_code, off_id, req_dt, br_id2, doc_bit, doc_no){
		window.open('cons_req_doc_tot.jsp<%=valus%>&req_code='+req_code+'&off_id='+off_id+'&req_dt='+req_dt+'&br_id2='+br_id2+'&doc_bit='+doc_bit+'&doc_no='+doc_no+'&mode='+document.form1.mode.value+'&from_page='+document.form1.from_page.value, "CONS_LIST", "left=0, top=0, width=1000, height=768, scrollbars=yes, status=yes, resizable=yes");
	}
	
		
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
	
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
	     
		theURL = "https://fms3.amazoncar.co.kr/data/consignment/"+theURL;
		
		popObj = window.open('',winName,features);
		popObj.location = theURL
		popObj.focus();
		
	}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">
<!--<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" viewastext codebase="http://www.meadroid.com/scriptx/smsx.cab#Version=6,3,435,20">-->
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
  <input type='hidden' name='br_id2' 	value='<%=br_id2%>'>  
  <input type='hidden' name='doc_bit' 	value='<%=doc_bit%>'>
  <input type='hidden' name='doc_no' 	value='<%=doc_no%>'>
  <input type='hidden' name='size' 		value='<%=vt_size%>'>
  <input type='hidden' name='off_nm' 	value='<%=c61_soBn.getOff_nm()%>'>
  <input type='hidden' name='user_dt1' 		value='<%=doc.getUser_dt1()%>'>
  <input type='hidden' name='msg_send_bit' 	value=''>
  <input type='hidden' name='d_cons_no' 	value=''>

  <table border="0" cellspacing="0" cellpadding="0" width=1010>
    <tr>
      <td>&lt; 탁송료 청구 리스트 &gt; </td>
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
		    <td style="font-size:8pt" width='25' rowspan="3" align='center'>연번</td>
		    <td style="font-size:8pt" width='50' rowspan="3" align='center'>탁송일자</td>			
		    <td style="font-size:8pt" width='75' rowspan="3" align='center'>탁송사유</td>
		    <td style="font-size:8pt" width='75' rowspan="3" align='center' >차량번호</td>
		    <td style="font-size:8pt" width='90' rowspan="3" align='center'>차명</td>
		    <td style="font-size:8pt" width='90' rowspan="3" align='center'>출발장소</td>
		    <td style="font-size:8pt" width='90' rowspan="3" align='center'>도착장소</td>
		    <td style="font-size:8pt" colspan="9" align='center'>청구금액</td>
		    <td style="font-size:8pt" width="60" rowspan="3" align='center'>운전자</td>
		    <td style="font-size:8pt" width="45" rowspan="3" align='center'>담당자</td>
		<!--     <td style="font-size:8pt" width="45" rowspan="2" align='center'>등록자</td>		-->	
	      </tr>
		  <tr valign="middle" align="center">
		    <td style="font-size:8pt" width='60' align='center' rowspan="2">탁송료</td>
		    <td style="font-size:8pt" width='50' align='center' rowspan="2">유류비</td>
		    <td style="font-size:8pt" width='45' align='center' rowspan="2">세차비</td>
		    <td style="font-size:8pt" width='45' align='center' rowspan="2">세차<br>수수료</td>
		    <td style="font-size:8pt" colspan=4 align='center'>기타</td>
		    <td style="font-size:8pt" width='60' align='center' rowspan="2">합계</td>
		  </tr>
		  <tr valign="middle" align="center">
		    <td style="font-size:8pt" width='45' align='center'>외부<br>탁송료</td>
		    <td style="font-size:8pt" width='45' align='center'>주차비</td>
		    <td style="font-size:8pt" width='45' align='center'>보증수리<br/>대행</td>
		    <td style="font-size:8pt" width='45' align='center'>검사대행</td>		 
		  </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				String tint_dt = String.valueOf(ht.get("FROM_DT"));
				if(tint_dt.length() >= 8){
					tint_dt = tint_dt.substring(0,8);
				}
				if(tint_dt.length() == 0){
					tint_dt = String.valueOf(ht.get("REG_DT"));
				}
				
				
				String content_code = "CONSIGNMENT";
				String content_seq  = String.valueOf(ht.get("CONS_NO"))+String.valueOf(ht.get("SEQ"));

				Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
				int attach_vt_size = attach_vt.size();

				String file_type1 = "";
				String seq1 = "";
				String file_type2 = "";
				String seq2 = "";

				String file_name1 = "";
				String file_name2 = "";

				for(int j=0; j< attach_vt.size(); j++){
					Hashtable ht2 = (Hashtable)attach_vt.elementAt(j);   
					
						file_name1 = String.valueOf(ht2.get("FILE_NAME"));
						file_type1 = String.valueOf(ht2.get("FILE_TYPE"));
						seq1 = String.valueOf(ht2.get("SEQ"));

				}
									
				
				%>
		  <tr> 
		    <td style="font-size:8pt" align='center'><%=i+1%><input type='hidden' name='cons_no' value='<%=ht.get("CONS_NO")%>'><input type='hidden' name='seq' value='<%=ht.get("SEQ")%>'></td>
		    <td style="font-size:8pt" align='center'><%=tint_dt%></td>						
		    <td style="font-size:8pt" align='center'><%=ht.get("CONS_CAU_NM")%></td>
		    <td style="font-size:8pt" align='center'><%=ht.get("CAR_NO")%></td>
		    <td style="font-size:8pt" align='center'><%=ht.get("CAR_NM")%></td>			
		    <td style="font-size:8pt" align='center'><span title='<%=ht.get("FROM_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("FROM_PLACE")), 8)%></span></td>
		    <td style="font-size:8pt" align='center'><span title='<%=ht.get("TO_PLACE")%>'><%=Util.subData(String.valueOf(ht.get("TO_PLACE")), 8)%></span></td>
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_AMT")))%></td>
		 
		    <td style="font-size:8pt" align='right'>
			
			 <%if(file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
					<%if(!String.valueOf(ht.get("OIL_AMT")).equals("0")){%>
					 <a href="javascript:openPopP('<%=file_type1%>','<%=seq1%>');" title='보기' ><%=AddUtil.parseDecimal(String.valueOf(ht.get("OIL_AMT")))%></a>
					 <%}else{%>
					 <%=AddUtil.parseDecimal(String.valueOf(ht.get("OIL_AMT")))%>
					 <%}%>
					 <%}else{%>
					 <a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq1%>" target='_blank'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OIL_AMT")))%></a>
					 <%}%>
			
			</td>			
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_AMT")))%></td>
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("WASH_FEE")))%></td>
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_OTHER_AMT")))%></td>
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OTHER_AMT")))%></td>
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("ETC1_AMT")))%></td>
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("ETC2_AMT")))%></td>
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>
		    <td style="font-size:8pt" align='center'><%=ht.get("DRIVER_NM")%></td>						
		    <td style="font-size:8pt" align='center'><%=ht.get("USER_NM1")%></td>
		    <!-- 
		    <td style="font-size:8pt" align='center'>
			<%if(doc.getUser_id1().equals("") && ( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사고객지원팀출납",user_id) || nm_db.getWorkAuthUser("탁송관리자",user_id) ) ){%>
			<a href="javascript:doc_cancel('<%=ht.get("CONS_NO")%>')" title='청구리스트에서 빼기'><%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%></a>
			<%}else{%>
			<%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%>
			<%}%>
			</td> -->			
		  </tr>
  <%		total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("CONS_AMT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("OIL_AMT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("WASH_AMT")));
			total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("OTHER_AMT")));
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT")));
			total_amt8 	= total_amt8 + AddUtil.parseLong(String.valueOf(ht.get("WASH_FEE")));
			total_amt11 	= total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("CONS_OTHER_AMT")));
			total_amt12 	= total_amt12 + AddUtil.parseLong(String.valueOf(ht.get("ETC1_AMT")));
			total_amt13 	= total_amt13 + AddUtil.parseLong(String.valueOf(ht.get("ETC2_AMT")));
			
		  }%>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>					
					<td>&nbsp;</td>					
					<td>&nbsp;</td>					
					<td>&nbsp;</td>										
					<td>&nbsp;</td>										
					<td>&nbsp;</td>					
					<td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt1)%></td>				
					<td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt2)%></td>					
					<td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt3)%></td>	
					<td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt8)%></td>	
					<td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt11)%></td>														
				    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt4)%></td>
				    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt12)%></td>
				    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt13)%></td>
				    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt5)%></td>
					<td>&nbsp;</td>										
					<td>&nbsp;</td>																			
																						
				</tr>		  
	    </table>
	  </td>
	</tr>
	<tr>
		<td align="right">
		<%//if(nm_db.getWorkAuthUser("전산팀",user_id)){%>	
			<!-- <a href="javascript:cons_doc_tot('<%=req_code%>', '<%=off_id%>', '<%=req_dt%>', '<%=pay_dt%>', '<%=br_id%>', '', '<%=doc_no%>');">기사별현황</a> -->
			<%//}%>
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
            <td width="300" class=line>
			  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
			  <tr><td class=line2></td></tr>
                <tr valign="middle" align="center">
                  <td width='30' rowspan="2" align='center'>결<br>재</td>
                  <td width='80' align='center'>지점명</td>
                  <td width='90' align='center'>탁송관리자</td>
		  <%if(br_id2.equals("S1")||br_id2.equals("S2")||br_id2.equals("I1")||br_id2.equals("K3")||br_id2.equals("S3")||br_id2.equals("S4")){%>
                  <td width='100' align='center' >총무팀장</td>
		  <%}else{%>
                  <td width='190' align='center'>지점장</td>
		  <%}%>
                </tr>
                <tr>
                  <td align='center'><%=c_db.getNameById(br_id2,"BRCH")%></td>
                  <td align='center'><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%><%if(doc.getUser_dt1().equals("")){%><a href="javascript:doc_sanction('1')">결재</a><br>&nbsp;<%}else{%><%if(doc.getUser_dt2().equals("")){%><%if(doc.getUser_id1().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%><br><a href="javascript:msg_send('2')">결재요청</a><%}%><%}%><%}%></td>
                  <td align='center'><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%><%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("")){%><%if(doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("차량대금팀장결재대행",user_id)){%><a href="javascript:doc_sanction('2')">결재</a><br>&nbsp;<%}%><%}%></td>				
                </tr>
              </table>
			</td>
			<td width="660">&nbsp;</td>
          </tr>
        </table>		  
	  </td>	
	</tr>
	<!--미지급금전표발행-->
	<%		if(!doc.getUser_id1().equals("") && ( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사고객지원팀출납",user_id) || nm_db.getWorkAuthUser("탁송관리자",user_id) ) ){%>
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
            <td width="800" class=line>
			  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
			  <tr><td class=line2></td></tr>
                <tr>
                  <td width="30%" align='center'>전표일자</td>
                  <td width="70%">&nbsp;<input type='text' name='autodocu_dt' value='<%=AddUtil.ChangeDate2(req_dt)%>' maxlength='11' size='11' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>
                <tr>
                  <td width="30%" align='center'>금액</td>
                  <td width="70%">
				    &nbsp;공급가 : <input type='text' name='autodocu_s_amt' value='<%=total_amt5%>' maxlength='15' size='10' class='num' >
				    &nbsp;부가세 : <input type='text' name='autodocu_v_amt' value='<%=AddUtil.parseFloatTruncZero(String.valueOf(total_amt5*0.1))%>' maxlength='15' size='10' class='num' >				  
				  </td>
                </tr>				
              </table>
			</td>
			<td width="560">&nbsp;<%//if(!doc.getUser_dt1().equals("")){%><a href="javascript:autodocu_reg()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_jpbh_mgg.gif border=0 align=absmiddle></a><%//}%></td>
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
  <input type='hidden' name='cons_other_amt' 	value='<%=total_amt11%>'>
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
