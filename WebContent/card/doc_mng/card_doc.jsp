<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*, acar.util.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
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
	String dept_id 	= request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String buy_dt 	= request.getParameter("buy_dt")==null?"":request.getParameter("buy_dt");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
		
	CommonDataBase c_db = CommonDataBase.getInstance();

	Vector vts = CardDb.getCardDocList2(  gubun1,  dept_id,  st_dt, end_dt, buy_dt );
	int vt_size = vts.size();
		
	long total_amt = 0;	
	long total_s_amt = 0;	
	long total_v_amt = 0;	
	
	String chief_id = "";
	
	String s_gubun = "X";
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&buy_dt="+buy_dt+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+
				   	"";
	
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
			fm.action = 'pay_d_frame.jsp';
		}			
		fm.target = 'd_content';
		fm.submit();
	}	
		

//카드내용보기
	function CardDocUpd(cardno, buy_id, doc_mng_id, buy_user_id){
		var fm = document.form1;
		
				fm.cardno.value = cardno;
				fm.buy_id.value = buy_id;		
				fm.action = "doc_reg_us.jsp";
				window.open("about:blank", "CardDocView", "left=20, top=50, width=1200, height=700, scrollbars=yes, status=yes");
				fm.target = "CardDocView";
				fm.submit();
	}
	
	
	
	//부서장결재
	function doc_card_gj(){
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					cnt++;					
				}
			}
		}	
		
		if(cnt == 0){
		 	alert("1건이상 선택하세요.");
			return;
		}	
		
		fm.target = "i_no";		
		fm.action = "card_gj_many_a.jsp";
		fm.submit();	
	}
	
		//전체선택
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
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
		
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
 
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='s_kd' 	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>
 
 <input type="hidden" name="cardno" >
<input type="hidden" name="buy_id" >
<input type="hidden" name="s_gubun"  value='<%=s_gubun%>' >

<table border="0" cellspacing="0" cellpadding="0" width='1050'>
    <tr><td class=line2 colspan=2></td></tr>    
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='50%' id='td_title' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='8%' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>		  
                    <td width='8%' class='title'>연번</td>  
                    <td width='25%' class='title'>카드번호</td>
                    <td width='10%' class='title'>소유자</td>
                    <td width='10%' class='title'>사용자</td>
                    <td width='14%' class='title'>거래일자</td>
                    <td width='25%' class='title'>거래처</td>
                </tr>
            </table>
        </td>
	    <td class='line' width='50%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>        
                    <td width='20%' class='title'>계정과목</td>          
                    <td width='15%' class='title'>금액</td>	
                    <td width='35%' class='title'>구분</td>
                    <td width='15%' class='title'>등록일자</td>
                    <td width='15%' class='title'>등록자</td>			
              
                </tr>
            </table>
	    </td>
    </tr>
<%	if(vt_size > 0){%>
    <tr>
	    <td class='line' width='50%' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);%>
                <tr> 
                    <td width='8%' align="center"><input type="checkbox" name="ch_cd" value="<%=ht.get("CARDNO")%>^<%=ht.get("BUY_ID")%>"></td>
        			<td width='8%' align="center"><%=i+1%></td>
                    <td width='25%' align="center"><%=ht.get("CARDNO")%></td>
                    <td width='10%' align="center"><%=ht.get("OWNER_NM")%></td>
                    <td width='10%' align="center"><%=ht.get("USER_NM")%></td>
                    <td width='14%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BUY_DT")))%></td>
                    <td width='25%' align="center"><a href="javascript:CardDocUpd('<%=ht.get("CARDNO")%>','<%=ht.get("BUY_ID")%>','<%=ht.get("DOC_MNG_ID")%>','<%=ht.get("BUY_USER_ID")%>')"><span title='<%=ht.get("VEN_NAME")%>'><%=Util.subData(String.valueOf(ht.get("VEN_NAME")), 6)%></span></a></td>
                </tr>
          <%}%>
                <tr align="center">
                    <td class="title"></td>
        			<td class="title"></td>
                    <td class="title"></td>
                    <td class="title"></td>
                    <td class="title"></td>
                    <td class="title">합계</td>
                    <td class="title"></td>
                    <td class="title"></td>
                    <td class="title"></td>
                    <td class="title"></td>			
                </tr>		 				  
            </table>
        </td>
	    <td class='line' width='50%'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
              <%for(int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vts.elementAt(i);%>
                <tr> 
              	  <td width='20%' align="center"><%=ht.get("ACCT_CODE_NM")%></td>
                    <td width='15%' align="right"><%=Util.parseDecimal(String.valueOf(ht.get("BUY_AMT")))%>원&nbsp;</td>            
                    <td width='35%' align="center"><%=Util.subData(String.valueOf(ht.get("ACCT_CODE_G_NM"))+""+String.valueOf(ht.get("ACCT_CODE_G2_NM")), 15)%></td>
                    <td width='15%' align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
                    <td width='15%' align="center"><%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%></td>					
               
                </tr>
              <%	total_amt = total_amt + Long.parseLong(String.valueOf(ht.get("BUY_AMT")));
    			
    		  	}%>
                <tr align="center">
                    <td class="title"></td>		
                    <td style="text-align:right" class="title"><%=Util.parseDecimal(total_amt)%>원&nbsp;</td>						
                    <td class="title"></td>
                    <td class="title"></td>
                    <td class="title"></td>			
             
                </tr>		 				  			
            </table>
	    </td>
    </tr>
<%	}else{%>                     
	<tr>
		<td class='line' width='50%' id='td_con' style='position:relative;'> 
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr> 
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width='50%'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'></td>
				</tr>
			</table>
		</td>
    </tr>
      
<% 	}%>

	<tr><td class=h></td></tr>
	<tr>
	
		<td align="left">
		<%if(!s_gubun.equals("X")){%>	<a href="javascript:doc_card_gj()"><img src=/acar/images/center/button_conf.gif border=0 align=absmiddle></a><%}%>&nbsp;	
					
			<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
		</td>
	</tr>
				
</table>
</form>

<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
