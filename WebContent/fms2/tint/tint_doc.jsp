<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.cus0601.*" %>
<%@ page import="acar.util.*, acar.tint.*, acar.user_mng.*, acar.doc_settle.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
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
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//????????
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	if(doc_no.equals("")){
		doc = d_db.getDocSettleCommi("7", req_code);
		doc_no = doc.getDoc_no();
	}
	
	user_bean 	= umd.getUsersBean(doc.getUser_id1());
	
	Vector vt = new Vector();
	if(doc_no.equals("")){
		vt = t_db.getTintNotPayOffList(off_id, req_dt, br_id2);
	}else{
		vt = t_db.getTintReqDocList(req_code);
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
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
	long total_amt11 = 0;
	
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
	//??????
	function list(){
		var fm = document.form1;		
		fm.action = '<%=from_page%>';		
		fm.target = 'd_content';
		fm.submit();
	}	

	function doc_sanction(doc_bit){
		var fm = document.form1;
		fm.doc_bit.value = doc_bit;
		
		if(confirm('?????????????????')){	
			fm.action='tint_doc_sanction.jsp';		
//			fm.target='i_no';
			fm.submit();
		}									
	}
	
	function msg_send(msg_send_bit){
		var fm = document.form1;
		
		if(confirm('???????? ???????????????????')){	
			fm.msg_send_bit.value = msg_send_bit;		
			fm.action='tint_doc_sanction.jsp';		
//			fm.target='i_no';
			fm.submit();
		}						
	}	
	
	//??????????????
	function autodocu_reg(){
		var fm = document.form1;
				
		if(confirm('?????????????? ?????????????????')){
			fm.action='tint_doc_autodocu_reg.jsp';		
			fm.target = 'i_no';
//			fm.target = '_blank';
			fm.submit();		
		}
	}				
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
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
  <input type='hidden' name='msg_send_bit' 	value=''>  

  <table border="0" cellspacing="0" cellpadding="0" width=1000>
    <tr>
      <td>&lt; ???????? ???? ?????? &gt; </td>
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
                  <td width="10%" align='center'>????????</td>		  
                  <td width="23%" align='center'><%=c61_soBn.getOff_nm()%></td>
                  <td width="10%" align='center'>????????</td>
                  <td width="23%" align='center'><%=c61_soBn.getBank()%></td>
                  <td width="10%" align='center'>????????</td>
                  <td align='center'><%=c61_soBn.getAcc_no()%></td>
                </tr>
                <tr>
		          <td align='center'>????????</td>
                  <td align='center'><%=AddUtil.ChangeDate2(req_dt)%></td>
                  <td align='center'>??????</td>
                  <td align='center'><%=vt_size%>??</td>
                  <td align='center'>??????????</td>
                  <td align='center'><input type='text' name="req_amt" value='' size='10' class='whitenum' readonly>??</td>
                </tr>
              </table>
			</td>
			<td width="200">&nbsp;</td>
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
		<tr><td class=line2></td></tr>
		  <tr valign="middle" align="center"> 
		    <td style="font-size:8pt" width='25' rowspan="2" align='center'>????</td>
		    <td style="font-size:8pt" width='130' rowspan="2" align='center'>????</td>
		    <td style="font-size:8pt" width='85' rowspan="2" align='center' >????????</td>
		    <td style="font-size:8pt" width='110' rowspan="2" align='center'>????</td>
		    <td style="font-size:8pt" width='50' rowspan="2" align='center'>????????</td>
		    <td style="font-size:8pt" width='100' rowspan="2" align='center'>????????</td>
		    <td style="font-size:8pt" colspan="6" align='center'>????????</td>
		    <!--
		    <td style="font-size:8pt" width="60" rowspan="2" align='center'>????????</td>
		    <td style="font-size:8pt" colspan="2" align='center'>????????</td>
		    <td style="font-size:8pt" colspan="2" align='center'>????</td>
		    -->
		    <td style="font-size:8pt" width="50" rowspan="2" align='center'>??????</td>					    
	      </tr>
		  <tr valign="middle" align="center">
		    <td style="font-size:8pt" width='60' align='center'>??????</td>
		    <td style="font-size:8pt" width='60' align='center'>??????????</td>
		    <td style="font-size:8pt" width='60' align='center'>??????????</td>
		    <td style="font-size:8pt" width='60' align='center'>????????</td>
		    <td style="font-size:8pt" width='60' align='center'>????????</td>
		    <td style="font-size:8pt" width='60' align='center'>????</td>
		    <!--
		    <td style="font-size:8pt" width='60' align='center'>????????</td>
		    <td style="font-size:8pt" width='60' align='center'>????????</td>
		    <td style="font-size:8pt" width='60' align='center'>????</td>
		    <td style="font-size:8pt" width='60' align='center'>??????????</td>												
		    -->
		  </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
		  <tr> 
		    <td style="font-size:8pt" align='center'><%=i+1%><input type='hidden' name='tint_no' value='<%=ht.get("TINT_NO")%>'></td>
			<%if(String.valueOf(ht.get("TINT_ST")).equals("2")){%>
			<td colspan="4" style="font-size:8pt" align='center'><%=ht.get("ETC")%></td>
			<%}else{%>
		    <td style="font-size:8pt" align='center'><%=ht.get("FIRM_NM")%></td>
		    <td style="font-size:8pt" align='center'><%=ht.get("CAR_NO")%></td>
		    <td style="font-size:8pt" align='center'><%=ht.get("CAR_NM")%></td>			
		    <td style="font-size:8pt" align='center'><%=ht.get("BUS_ST_NM")%></td>			
			<%}%>
		    <td style="font-size:8pt" align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("SUP_DT")))%></td>
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TINT_AMT")))%></td>
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CLEANER_AMT")))%></td>			
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("NAVI_AMT")))%></td>
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("BLACKBOX_AMT")))%></td>
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("OTHER_AMT")))%></td>
		    <td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>
		    <!--
			<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("A_AMT")))%></td>
			<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("E_SUB_AMT1")))%></td>
			<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("E_SUB_AMT2")))%></td>					
			<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("C_SUB_AMT1")))%></td>
			<td style="font-size:8pt" align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("C_SUB_AMT2")))%></td>					
			-->
		    <td style="font-size:8pt" align='center'><%=ht.get("USER_NM1")%></td>
		  </tr>
  <%		total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("TINT_AMT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("CLEANER_AMT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("NAVI_AMT")));
			total_amt11 	= total_amt11 + AddUtil.parseLong(String.valueOf(ht.get("BLACKBOX_AMT")));
			total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("OTHER_AMT")));
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("A_AMT")));
			total_amt7 	= total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("E_SUB_AMT1")));
			total_amt8 	= total_amt8 + AddUtil.parseLong(String.valueOf(ht.get("E_SUB_AMT2")));
			total_amt9 	= total_amt9 + AddUtil.parseLong(String.valueOf(ht.get("C_SUB_AMT1")));
			total_amt10 = total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("C_SUB_AMT2")));
			
		  }%>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>					
					<td>&nbsp;</td>					
					<td>&nbsp;</td>					
					<td>&nbsp;</td>					
					<td>&nbsp;</td>					
					<td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt1)%></td>
					<td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt2)%></td>					
					<td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt3)%></td>															
					<td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt11)%></td>															
				    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt4)%></td>
				    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt5)%></td>
				    <!--
					<td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt6)%></td>					
					<td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt7)%></td>															
				    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt8)%></td>
				    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt9)%></td>
				    <td style="font-size:8pt" align='right'><%=Util.parseDecimal(total_amt10)%></td>					
				    -->
					<td>&nbsp;</td>										
				</tr>		  
	    </table>
	  </td>
	</tr>
	<tr>
		<td align="right">
		  <a href="javascript:print()"><img src=/acar/images/center/button_print.gif border=0 align=absmiddle></a><font color=#CCCCCC>&nbsp;(??????TIP : A4, ????????)</font>&nbsp;&nbsp;
		  <a href="javascript:window.close();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
		</td>	
	</tr>	
	<tr>
		<td>&nbsp;</td>	
	</tr>	
	<%if(!nm_db.getWorkAuthUser("????????????",user_id)){%>	
	<tr>
	  <td>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width="300" class=line>
			  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
			  <tr><td class=line2></td></tr>
                <tr valign="middle" align="center">
                  <td width='30' rowspan="2" align='center'>??<br>??</td>
                  <td width='80' align='center'>??????</td>
		  <%if(br_id2.equals("S1")||br_id2.equals("S2")||br_id2.equals("I1")){%>
                  <td width='90' align='center'>??????????</td>
                  <td width='100' align='center' >????????</td>
		  <%}else{%>
                  <td width='190' align='center'>??????</td>
		  <%}%>
                </tr>
                <tr>
                  <td align='center'><%=c_db.getNameById(br_id2,"BRCH")%></td>
				  <%if(br_id2.equals("S1")){%>
                  <td align='center'><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%><%if(doc.getUser_dt1().equals("")){%><a href="javascript:doc_sanction('1')">????</a><br>&nbsp;<%}else{%><%if(doc.getUser_dt2().equals("")){%><%if(doc.getUser_id1().equals(user_id) || nm_db.getWorkAuthUser("??????",user_id)){%><br><a href="javascript:msg_send('2')">????????</a><%}%><%}%><%}%></td>
                  <td align='center'><%=c_db.getNameById(doc.getUser_id2(),"USER_PO")%><br><%=doc.getUser_dt2()%><%if(!doc.getUser_dt1().equals("") && doc.getUser_dt2().equals("")){%><%if(doc.getUser_id2().equals(user_id) || nm_db.getWorkAuthUser("??????",user_id)){%><a href="javascript:doc_sanction('2')">????</a><br>&nbsp;<%}%><%}%></td>				
				  <%}else{%>
                  <td align='center'><%=c_db.getNameById(doc.getUser_id1(),"USER_PO")%><br><%=doc.getUser_dt1()%><%if(doc.getUser_dt1().equals("")){%><a href="javascript:doc_sanction('1')">????</a><br>&nbsp;<%}%></td>
				  <%}%>				  
                </tr>
              </table>
			</td>
			<td width="700">&nbsp;</td>
          </tr>
        </table>		  
	  </td>	
	</tr>
	
	<!--????????????????-->
	<%		if(!doc.getUser_id1().equals("") && ( nm_db.getWorkAuthUser("??????",user_id) || nm_db.getWorkAuthUser("??????????????????",user_id) || nm_db.getWorkAuthUser("??????????",user_id) || nm_db.getWorkAuthUser("??????????????",user_id) ) ){%>
	<tr>
		<td>&nbsp;</td>	
	</tr>
	<tr>
		<td><hr></td>	
	</tr>
    <tr>
      <td>&lt; ?????? ???????? ???????? &gt; </td>
    </tr>  
	<tr>
	  <td>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width="480" class=line>
			  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
			  <tr><td class=line2></td></tr>
                <tr>
                  <td width="30%" align='center'>????????</td>
                  <td width="70%">&nbsp;<input type='text' name='autodocu_dt' value='<%=AddUtil.ChangeDate2(req_dt)%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>
                <tr>
                  <td width="30%" align='center'>????</td>
                  <td width="70%">
				    &nbsp;?????? : <input type='text' name='autodocu_s_amt' value='<%=total_amt5%>' maxlength='15' size='10' class='num' >
					&nbsp;?????? : <input type='text' name='autodocu_v_amt' value='<%=AddUtil.parseFloatTruncZero(String.valueOf(total_amt5*0.1))%>' maxlength='15' size='10' class='num' >				  
				  </td>
                </tr>
              </table>
			</td>
			<td width="520">&nbsp;<%//if(!doc.getUser_dt1().equals("")){%><a href="javascript:autodocu_reg()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_jpbh_mgg.gif border=0 align=absmiddle></a><%//}%></td>
          </tr>
        </table>		  
	  </td>	
	</tr>		
	<tr>
		<td>?? ???????? ???????? ?????? ?????????? ??????????. ?????????? ??????????????.</td>	
	</tr>
	<%		}%>	
			
	<%}%>	
  </table>
  <input type='hidden' name='tint_amt' 	  	value='<%=total_amt1%>'>
  <input type='hidden' name='cleaner_amt' 	value='<%=total_amt2%>'>
  <input type='hidden' name='navi_amt' 		value='<%=total_amt3%>'>
  <input type='hidden' name='other_amt' 	value='<%=total_amt4%>'>
  <input type='hidden' name='tot_amt' 		value='<%=total_amt5%>'>        
  <input type='hidden' name='a_amt' 		value='<%=total_amt6%>'>
  <input type='hidden' name='e_sub_amt1' 	value='<%=total_amt7%>'>
  <input type='hidden' name='e_sub_amt2' 	value='<%=total_amt8%>'>
  <input type='hidden' name='c_sub_amt1' 	value='<%=total_amt9%>'>        
  <input type='hidden' name='c_sub_amt2' 	value='<%=total_amt10%>'>          
</form>  
<script language='javascript'>
<!--
	document.form1.req_amt.value = '<%=Util.parseDecimal(total_amt5)%>';
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
