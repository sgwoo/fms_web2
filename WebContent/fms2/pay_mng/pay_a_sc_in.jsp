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
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt =  pm_db.getPayAList(s_kd, t_wd, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4, gubun5);
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
	/* Title 고정 */
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
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='req_dt'    value=''>      
  <input type='hidden' name='from_page' value='/fms2/pay_mng/pay_a_frame.jsp'>  
<table border="0" cellspacing="0" cellpadding="0" width='1350'>
  <tr id='tr_title' style='position:relative;z-index:1'>
  	<tr><td class=line2 colspan="2"></td></tr>		
    <td class='line' width='530' id='td_title' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr> 
          <td width='30' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
          <td width='50' class='title' style='height:51'>연번</td>              
		  <td width='40' class='title'>출금<br>시간</td>
		  <td width="50" class='title'>등록자</td>		
          <td width='200' class='title'>출금항목</td>		  
          <td width="80" class='title'>거래일자</td>				  
          <td width="80" class='title'>예정일자</td>				  		  
        </tr>
      </table>
	</td>
	<td class='line' width='820'>
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		  <td colspan="3" class='title'>송금결재</td>		
      <td width="100" rowspan="2" class='title'>금액</td>		  
		  <td width="200" rowspan="2" class='title'>지출처</td>
		  <td width='80' rowspan="2" class='title'>출금방식</td>					  
		  <td width="200" rowspan="2" class='title'>적요</td>			  
		</tr>
		<tr>
		  <td width="80" class='title'>문서</td>		
		  <td width="80" class='title'>요청자</td>
		  <td width="80" class='title'>팀장</td>		  
		</tr>
	  </table>
	</td>
  </tr>
  <%if(vt_size > 0){%>
  <tr>		
    <td class='line' width='530' id='td_con' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
        <tr> 
          <td width='30' align='center'>
		  <%if(String.valueOf(ht.get("BANK_CODE")).equals("")){%>
		  <input type="checkbox" name="ch_cd" value="<%=ht.get("REQSEQ")%>">
		  <%}else if(!String.valueOf(ht.get("BANK_CODE")).equals("") && String.valueOf(ht.get("USER_DT1")).equals("")){%>
		  <input type="checkbox" name="ch_cd" value="<%=ht.get("REQSEQ")%>">
		  <%}%>
		  </td>
          <td width='50' align='center'><%=i+1%></td>	
		  <td width='40' align='center'>
		  <%if(String.valueOf(ht.get("AT_ONCE")).equals("Y")){%>
		  <font color=red>즉시</font>
		  <%}else{%>
		  지정
		  <%}%>
		  </td>		 
		  <td width='50' align='center'><%=ht.get("REG_NM")%></td>		  		  		    		  		  		  
  		  <td width='200' align='center'><%=ht.get("GUBUN_NM")%></td>
          <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("P_EST_DT")))%></td>
          <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("P_EST_DT2")))%><%//=AddUtil.ChangeDate2(String.valueOf(ht.get("P_REQ_DT")))%></td>		  
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
				</tr>
      </table>
	</td>
	<td class='line' width='820'>
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				//은행코드 가져오기
				if(String.valueOf(ht.get("BANK_ID")).equals("")){
					
				}
				total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
				%>
		<tr>
		  <td width='80' align='center'><%=ht.get("DOC_NO2")%></td>		
		  <td width='80' align='center'>
		  <%if(!String.valueOf(ht.get("USER_DT1")).equals("")){%>
		  <a href="javascript:parent.doc_action('2', '<%=ht.get("BANK_CODE")%>', '<%=ht.get("DOC_NO")%>');"><%=ht.get("USER_NM1")%></a>
		  <%}%>
		  </td>
		  <td width='80' align='center'>
		    <%if(!String.valueOf(ht.get("USER_DT1")).equals("") && String.valueOf(ht.get("USER_DT2")).equals("")){%>
			<%	if(String.valueOf(ht.get("USER_ID2")).equals(user_id) || String.valueOf(ht.get("USER_ID1")).equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("회계업무",user_id) || nm_db.getWorkAuthUser("임원",user_id)){%>
			<a href="javascript:parent.doc_action('2', '<%=ht.get("BANK_CODE")%>', '<%=ht.get("DOC_NO")%>');"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
			<%	}else{%>-<%}%>
			<%}%>
			<%if(!String.valueOf(ht.get("USER_DT2")).equals("")){%>
			<a href="javascript:parent.doc_action('2', '<%=ht.get("BANK_CODE")%>', '<%=ht.get("DOC_NO")%>');"><%=ht.get("USER_NM2")%></a>
			<%}%>
		  </td>		
		  <td width='100' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></td>		  
		  <td width='200' align='center'><span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 15)%></span></td>
          <td width='80' align='center'>
		  <%if(String.valueOf(ht.get("P_WAY")).equals("1")){%><a href="javascript:parent.cng_pay_acc('<%=ht.get("REQSEQ")%>')" onMouseOver="window.status=''; return true" title="계좌이체로 변경할 수 있습니다."><%=ht.get("WAY_NM")%></a>
		  <%}else{%>
		  <%=ht.get("WAY_NM")%>
		  <%}%>
		  </td>         				  
		  <td width='200' align='center'><span title='<%=ht.get("P_CONT")%>'><%=Util.subData(String.valueOf(ht.get("P_CONT")), 15)%></span></td>	
		</tr>	
<%		}	%>
				<tr>						
				    <td class='title' colspan="3">합계</td>
					<td class='title' style='text-align:right;'><%=AddUtil.parseDecimalLong(total_amt1)%></td>					
				    <td class='title'>&nbsp;</td>					
				    <td class='title'>&nbsp;</td>	
				    <td class='title'>&nbsp;</td>						
				</tr>
	  </table>
	</td>
<%	}else{%>                     
    <tr>
	    <td class='line' width='530' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
                </table>
	    </td>
	    <td class='line' width='820'>
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

