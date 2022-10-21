<%@ page contentType="text/html; charset=euc-kr" language="java" %>
<%@ page import="java.util.*,acar.util.*,acar.user_mng.*"%>
<%@ page import="acar.client.*,acar.doc_settle.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%
	UserMngDatabase umd = UserMngDatabase.getInstance();

	String client_id = request.getParameter("client_id")==null? "":request.getParameter("client_id");
	int seq = request.getParameter("seq")==null?0:AddUtil.parseInt(request.getParameter("seq"));
	String current_date = AddUtil.getDate3();
	String gubun = request.getParameter("gubun")==null? "":request.getParameter("gubun");
	String crime = request.getParameter("crime")==null?"":request.getParameter("crime");
	
	//고객정보
	ClientBean client = al_db.getNewClient(client_id);
	
	//고객별 계약리스트
	Vector conts = new Vector();
	int cont_size = 0;
	
	if(seq == 0){
		conts = s_db.getContComplaintList(client_id);
		cont_size = conts.size();
	}else{
		conts = s_db.getContComplaintList(client_id, seq);
		cont_size = conts.size();	
	}
	
	String crime_name = "";
	String criminal_law = "";
	// 형법
	if(crime.equals("0")){
		crime_name = "횡령";
		criminal_law = "횡 령 (형법355조1항)";
	}
	
	DocSettleBean doc = d_db.getDocSettleCommi("49", client_id+""+String.valueOf(seq));
	UsersBean ub = umd.getUsersBean(doc.getUser_id1());
		
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
    <title>FMS</title>
    <!-- <link rel="stylesheet" type="text/css" href="/include/table_t.css"></link> -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<style>
	*{
		font-family: serif;
	}
</style>
</head>
<body topmargin=0 leftmargin=0 onLoad="javascript:onprint();">
<object id=factory style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,3,439,30">

</object>
	<table style="width:100%;margin:auto;">
		<tr><td colspan="2" style="height:80px;"></td></tr>
		<tr>
			<td colspan="2" align="center" style="font-weight:bold;"><font size="5">고 &nbsp;&nbsp;소 &nbsp;&nbsp;취 &nbsp;&nbsp;소 &nbsp;&nbsp;장</font></td>
		</tr>
		<tr><td colspan="2" style="height:110px;"></td></tr>
		<tr>
			<td style="vertical-align:top;width:10px;font-size:14px;font-weight:bold;text-align:right;">고 &nbsp;&nbsp;소 &nbsp;&nbsp;인 &#58;&nbsp;</td>
			<td style="font-size:14px">
				<p>(주)아마존카</p>
				<p>서울시 영등포구 의사당대로 8, 802 (여의도동, 태흥빌딩)</p>
				<p>대표이사 &nbsp;조 성 희 &nbsp;&nbsp;사무실:02-392-4242</p>
			</td>
		</tr>
		<tr><td colspan="2" style="height:60px;"></td></tr>
		<tr>
			<td style="vertical-align:top;font-size:14px;font-weight:bold;text-align:right;">고소대리인 &#58;&nbsp;</td>
			<td style="font-size:14px">
				<p><%=ub.getUser_nm()%> (생년월일: <%=ub.getUser_ssn().substring(0,6)%>)</p>
				<p>서울시 영등포구 의사당대로 8, 802 (여의도동, 태흥빌딩)</p>
				<p>휴대폰 : <%=ub.getUser_m_tel()%> &nbsp;&nbsp;사무실 : <%=ub.getHot_tel()%></p>
			</td>
		</tr>
		<tr><td colspan="2" style="height:60px;"></td></tr>
		<tr>
			<td style="vertical-align:top;font-size:14px;font-weight:bold;text-align:right;">피 &nbsp;고소인 &#58;&nbsp;</td>
			<td style="font-size:14px">
				<p><%=client.getClient_nm()%> (생년월일 : <%=client.getSsn1()%>)</p>
				<p><%if(!client.getO_addr().equals("")){%>
            		              ( 
            		              <%}%>
            		              <%=client.getO_zip()%> 
            		              <%if(!client.getO_addr().equals("")){%>
            		              )&nbsp; 
            		              <%}%>
            		              <%=client.getO_addr()%></p>
				<p>휴대폰 : <%=AddUtil.phoneFormat(client.getM_tel())%></p>
			</td>
		</tr>
		<tr><td colspan="2" style="height:40px;"></td></tr>
		<tr>
			<td style="font-size:14px;text-align:right;">죄 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명 &#58;&nbsp;</td>
			<td style="font-size:14px"><%=criminal_law%></td>
		</tr>
		<tr><td colspan="2" style="height:30px;"></td></tr>
		<tr>
			<td colspan="2" style="padding-left:50px;padding-right:50px;font-size:15px;font-family:Gulim;line-height:1.7em;" border=1>
				<span style="font-family:Gulim;">&nbsp;&nbsp;위 고소인은 피고소인을 <%=crime_name%> 혐의로 고소한 사실이 있으나, 차량</span>
				<span style="font-family:Gulim;">(<%
					if(cont_size > 0){
						for(int i=0; i<cont_size; i++){
							Hashtable cont = (Hashtable)conts.elementAt(i);
				%><%if(i>0){%>, <%}%><%=cont.get("CAR_NO")%>, <%=cont.get("CAR_NM")%>
				<%
						}
					}
				%>
				 )에 관하여 <%if(gubun.equals("1")){%>차량을<%}else{%>대여료를<%}%> 반납 받아 피고소인에 대한 형사상</span>
				<span style="font-family:Gulim;">처벌을 원하지 않으므로 고소 내용 전체를 취소하고자 합니다.</span>
			</td>
		</tr>
		<tr><td colspan="2" style="height:40px;"></td></tr>
		<tr>
			<td colspan="2" align="center" style="font-size:16px"><span style="font-family:Gulim;"><%=current_date%></span></td>
		</tr>
		<tr>
			<td colspan="2" style="text-align:center;"><img src="/acar/main_car_hp/images/ceo_text.jpg"></td>
		</tr>
	</table>
</body>
<script>
	function onprint(){
		factory.printing.header = ""; //폐이지상단 인쇄
		factory.printing.footer = ""; //폐이지하단 인쇄
		factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
		factory.printing.leftMargin = 5.0; //좌측여백   
		factory.printing.rightMargin = 5.0; //우측여백
		factory.printing.topMargin = 0.0; //상단여백    
		factory.printing.bottomMargin = 0.0; //하단여백
		factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
	}
</script>
</html>