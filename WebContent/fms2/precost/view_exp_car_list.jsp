<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.insur.*,acar.car_register.*"%>
<jsp:useBean id="ai_db" class="acar.insur.InsDatabase" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<jsp:useBean id="sBean" class="acar.offls_sui.SuiBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	var popObj = null;
	
	//팝업윈도우 열기
	function ScanOpen(theURL,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}	
		theURL = "https://fms3.amazoncar.co.kr/data/carReg/"+theURL+""+file_type;
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj = window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');			
		}else{
			popObj = window.open(theURL,'popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}
		popObj.location = theURL;
		popObj.focus();			
	}	
	
	function view_car_exp(car_mng_id){
		window.open('view_exp_car_list.jsp?car_mng_id='+car_mng_id, "VIEW_EXP_LIST", "left=0, top=0, width=850, height=768, scrollbars=yes, status=yes, resize");
	}

	//스캔한 등록증 보기
	function view_scanfile(path){
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("https://fms3.amazoncar.co.kr/data/carReg/"+path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}		
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	int total_su = 0;
	long total_amt = 0;
	long total_amt2 = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//차량정보
	CarRegDatabase crd = CarRegDatabase.getInstance();
	cr_bean = crd.getCarRegBean(car_mng_id);
	
	//차량번호 이력
	CarHisBean ch_r [] = crd.getCarHisAll(car_mng_id);
	
	//자동차세 이력
	Vector vt = ai_db.getExpCarList(car_mng_id);
	int vt_size = vt.size();
	
	//매각정보
	sBean = olsD.getSui(car_mng_id);
%>
<form name='form1' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=14%>최초등록일</td>
                    <td width=20%>&nbsp;<%=cr_bean.getInit_reg_dt()%></td>
                    <td class=title width=13%>지역</td>
                    <td width=20%>&nbsp;<%=c_db.getNameByIdCode("0032", "", cr_bean.getCar_ext())%></td>
                    <td class=title width=13%>관리번호</td>
                    <td width=20%>&nbsp;<%=cr_bean.getCar_doc_no()%></td>			
                </tr>
                <tr> 
                    <td class=title>자동차등록번호</td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td class=title>차종</td>
                    <td>&nbsp; 
                      <%=c_db.getNameByIdCode("0041", "", cr_bean.getCar_kd())%>                         
                    </td>
                    <td class=title>용도</td>
                    <td>&nbsp; 
                      <select name="car_use" disabled>
                        <option value="1" <%if(cr_bean.getCar_use().equals("1"))%> selected<%%>>영업용</option>
                        <option value="2" <%if(cr_bean.getCar_use().equals("2"))%> selected<%%>>자가용</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title>차명</td>
                    <td>&nbsp;<%=cr_bean.getCar_nm()%>
                    </td>
                    <td class=title>배기량</td>
                    <td>&nbsp;<%=cr_bean.getDpm()%></td>
                    <td class=title>승차정원</td>
                    <td>&nbsp;<%=cr_bean.getTaking_p()%></td>
                </tr>
                <tr> 
                    <td class=title>보유차</td>
                    <td>&nbsp;
        			  <%if(cr_bean.getPrepare().equals("")){%>예비차량<%}%>
        			  <%if(cr_bean.getPrepare().equals("1")){%>예비차량<%}%>
        			  <%if(cr_bean.getPrepare().equals("2")){%>매각예정<%}%>
        			  <%if(cr_bean.getPrepare().equals("3")){%>보류차량<%}%>
        			  <%if(cr_bean.getPrepare().equals("4")){%>말소차량<%}%>
        			  <%if(cr_bean.getPrepare().equals("5")){%>도난차량<%}%>
        			  <%if(cr_bean.getPrepare().equals("6")){%>경매차량<%}%>
        			  <%if(cr_bean.getPrepare().equals("7")){%>재리스비대상<%}%>
        			  <%if(cr_bean.getPrepare().equals("8")){%>수해차량<%}%>
                    </td>
                    <td class=title>오프리스</td>
                    <td colspan="3">&nbsp;
        			  <%if(cr_bean.getOff_ls().equals("")){%>예비차량<%}%>
        			  <%if(cr_bean.getOff_ls().equals("1")){%>매각결정<%}%>
        			  <%if(cr_bean.getOff_ls().equals("2")){%>소매<%}%>
        			  <%if(cr_bean.getOff_ls().equals("3")){%>출품차량<%}%>
        			  <%if(cr_bean.getOff_ls().equals("4")){%>수의<%}%>
        			  <%if(cr_bean.getOff_ls().equals("5")){%>낙찰차량<%}%>
        			  <%if(cr_bean.getOff_ls().equals("6")){%>매각차량<%}%>			  
        			</td>
                </tr>
            </table>  
	    </td>
	</tr>
	<tr>
	    <td></td>
	</tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량번호 이력</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>연번</td>
                    <td class=title width=15%>변경일자</td>
                    <td class=title width=15%>자동차관리번호</td>
                    <td class=title width=15%>사유</td>
                    <td class=title width=30%>상세내용</td>
                    <td class=title width=15%>등록증스캔</td>			
                </tr>
          <%if(ch_r.length > 0){
				for(int i=0; i<ch_r.length; i++){
			        ch_bean = ch_r[i];	%>
                <tr> 
                    <td align="center"><%=ch_bean.getCha_seq()%></td>
                    <td align="center"><%=ch_bean.getCha_dt()%></td>
                    <td align="center"><%=ch_bean.getCha_car_no()%></td>
                    <td align="center"> 
                      <% if(ch_bean.getCha_cau().equals("1")){%>
                      사용본거지 변경 
                      <%}else if(ch_bean.getCha_cau().equals("2")){%>
                      용도변경 
                      <%}else if(ch_bean.getCha_cau().equals("3")){%>
                      기타 
                      <%}else if(ch_bean.getCha_cau().equals("4")){%>
                      없음
                      <%}else if(ch_bean.getCha_cau().equals("5"))%>신규등록<%%>			  
        			  </td>
                    <td bgcolor="#FFFFFF">&nbsp;<%=ch_bean.getCha_cau_sub()%></td>
                    <td align="center" >&nbsp;
                    <%if(!ch_bean.getScanfile().equals("")){%>					
					<%		if(ch_bean.getFile_type().equals("")){%>
    			    <a href="javascript:view_scanfile('<%=ch_bean.getScanfile()%>');"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
					<%		}else{%>
    			    <a href="javascript:ScanOpen('<%= ch_bean.getScanfile() %>','<%= ch_bean.getFile_type() %>')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a> 					
					<%		}%>
        			<%} %>
        			</td>			
                </tr>
          <%	}
			}else{%>
                <tr> 
                    <td colspan=5 align=center height=25>등록된 데이타가 없습니다.</td>
                </tr>
          <%}%>
            </table>
        </td>
    </tr>	
	<%if(!sBean.getCar_mng_id().equals("")){%>
	<tr>
	    <td></td>
	</tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>매각정보</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td class=line>		
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
                <tr>
                    <td width="16%" class=title>매매일자</td>
                    <td width="32%">&nbsp;<%=sBean.getCont_dt()%></td>
                    <td width="16%" class=title>명의이전일</td>
                    <td>&nbsp;<%=sBean.getMigr_dt()%></td>
                </tr>	
                <tr>
                    <td width="16%" class=title>양수인</td>
                    <td width="32%">&nbsp;<%=sBean.getSui_nm()%></td>
                    <td width="16%" class=title>매매가</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(sBean.getMm_pr())%>원</td>
                </tr>	
                <tr>
                    <td width="16%" class=title>명의이전자</td>
                    <td width="32%">&nbsp;<%=sBean.getCar_nm()%> (<%=sBean.getCar_relation()%>)</td>
                    <td width="16%" class=title>이전후번호</td>
                    <td>&nbsp;<%=sBean.getMigr_no()%></td>
                </tr>	
            </table>		
        </td>
    </tr>			
	<%}%>
	<tr>
	    <td></td>
	</tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차세 이력</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr valign="middle" align="center"> 
        		    <td width='30' rowspan="2" class=title>연번</td>
        		    <td colspan="5" class=title>납부</td>
        		    <td colspan="5" class=title >환급</td>
	            </tr>
		        <tr valign="middle" align="center">
        		    <td width='120' class=title>기간</td>		  
        		    <td width='80' class=title>금액</td>		  
        		    <td width='80' class=title>납부일</td>		  			
        		    <td width="80" class=title>지역</td>
        		    <td width="80" class=title>차량번호</td>
        		    <td width='80' class=title>사유</td>		  
        		    <td width='80' class=title>사유발생일</td>		  
        		    <td width='80' class=title>신청일</td>
        		    <td width='80' class=title>금액</td>
        		    <td width='80' class=title>입금일</td>						
		        </tr>
<%		for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
		        <tr> 
        		    <td align='center'><%=i+1%></td>
        		    <td align='center'><%=ht.get("EXP_START_DT")%>~<%=ht.get("EXP_END_DT")%></td>
        		    <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("EXP_AMT")))%>원&nbsp;</td>
        		    <td align='center'><%=ht.get("EXP_DT")%></td>			
        		    <td align='center'><%=ht.get("CAR_EXT_NM")%></td>
        		    <td align='center'><%=ht.get("CAR_NO")%></td>			
        		    <td align='center'><%=ht.get("RTN_CAU_NM")%></td>
        		    <td align='center'><%=ht.get("RTN_CAU_DT")%></td>
        		    <td align='center'><%=ht.get("RTN_REQ_DT")%></td>			
        		    <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("RTN_AMT")))%>원&nbsp;</td>
        		    <td align='center'><%=ht.get("RTN_DT")%></td>
		        </tr>
  <%		total_amt = total_amt + Long.parseLong(String.valueOf(ht.get("EXP_AMT")));
		  	total_amt2 = total_amt2 + Long.parseLong(String.valueOf(ht.get("RTN_AMT")));
		  }%>
				<tr>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>					
					<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>원&nbsp;</td>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>					
					<td class="title">&nbsp;</td>										
					<td class="title">&nbsp;</td>					
					<td class="title">&nbsp;</td>															
					<td class="title">&nbsp;</td>															
					<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%>원&nbsp;</td>
					<td class="title">&nbsp;</td>					
				</tr>		  
	        </table>
	    </td>
	</tr>	
	<tr>
		<td align='right'>
		  <a href='javascript:window.close();'><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></a>
		</td>	
	</tr>	
</table>
</form>  
</body>
</html>
